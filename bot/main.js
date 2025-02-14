const fs = require('fs');

const mineflayer = require('mineflayer')
const pathfinder = require('mineflayer-pathfinder').pathfinder
const Movements = require('mineflayer-pathfinder').Movements
const { GoalNear } = require('mineflayer-pathfinder').goals
const pvp = require('mineflayer-pvp').plugin


const {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
  ChatSession,
} = require("@google/generative-ai");

const apiKey = process.env.GEMINI_API_KEY;
const historyFile = process.env.GEMINI_HISTORY_FILE;

const minecraftURL = process.env.MINECRAFT_URL;
const minecraftUser = process.env.MINECRAFT_USER;
const startingLocation = process.env.MINECRAFT_STARTING_LOCATION || "-1106 63 -1652";
const enableFollow = process.env.MINECRAFT_ENABLE_FOLLOW || "false";

const genAI = new GoogleGenerativeAI(apiKey);

const generationConfig = {
  temperature: 1,
  topP: 0.95,
  topK: 40,
  maxOutputTokens: 8192,
  responseMimeType: "text/plain",
};

const model = genAI.getGenerativeModel({
  model: "gemini-2.0-flash",
  systemInstruction: "You are a pirate captain when I ask you questions you will reply in pirate speak",
});

const options = {
  host: minecraftURL,
  port: 25565, // Change this to the port you want.
  auth: 'noauth',
  username: minecraftUser,
}

// we need to keep track of the chat sessions for each player
const sessions = new Map();

// default history for the chat session, this allows the bot to return specific responses for a question
const defaultHistory = JSON.parse(fs.readFileSync(historyFile, 'utf8'));

// if no login message is received in 30 seconds,restart the bot
var loginTimeout;

function createBot() {
  console.log("Bot starting");

  const bot = mineflayer.createBot(options)
  bot.loadPlugin(pathfinder);
  bot.loadPlugin(pvp);

  bot.on('spawn', () => {
    // teleport to the starting location
    console.log("Bot spawn, telporting to: " + startingLocation);
    bot.chat("/tp " + startingLocation);
    bot.chat("/gamemode creative");

    const defaultMove = new Movements(bot);
    defaultMove.canDig = false;
    defaultMove.canOpenDoors = true;
    defaultMove.blocksToAvoid.add(8);
    defaultMove.blocksToAvoid.add(9);

    bot.pathfinder.setMovements(defaultMove);
  });

  loginTimeout = setTimeout(() => {
    console.log("Bot login timeout");
    process.exit(1);
  }, 10000);

  bot.on('login', () => {
    console.log("Bot login");
    clearTimeout(loginTimeout);

  });

  bot.on('whisper', (username, message) => {
    if (username === bot.username) return

    var chatSession;

    // check if we have a session for this user
    if (!sessions.has(username)) {
      chatSession = model.startChat({
        generationConfig,
        history: defaultHistory
      });

      sessions.set(username, chatSession);
    } else {
      chatSession = sessions.get(username);
    }

    // look at the player
    if (bot.players[username].entity.position.distanceTo(bot.entity.position) < 15) {
      bot.lookAt(bot.players[username].entity.position.offset(0, 1.6, 0));
    }

    // send the message to Gemini
    const result = chatSession.sendMessage(message);
    result.then((result) => {
      const sanitized = result.response.text().replace(/([^a-z0-9 !?,"'\-\*]+)/gi, '');

      // split the message into 200 character lines
      const lines = splitStringByWordFixedLength(sanitized, 200);

      // send these back to the player with a delay to avoid getting kicked
      var n = 1;
      for (const line of lines) {
        setTimeout(() => {
          console.log("Sending: " + line);
          bot.chat("/msg " + username + " " + line);
        }, n * 500);
        n++;
      }

      if (enableFollow === "true") {
        // if the response contains follow me then tell the bot to move to that location
        const re = new RegExp("([-0-9]+),? ?([-0-9]+),? ?([-0-9]+),? ?");
        result = re.exec(sanitized);

        if (result != null) {
          console.log("Moving to: " + result[1] + "," + result[2] + "," + result[3]);
          bot.pathfinder.setGoal(new GoalNear(result[1], result[2], result[3], 1));
        }
      }

    });
  })

  // Called when the bot has killed it's target.
  bot.on('stoppedAttacking', () => {
    console.log("Stopped attacking");

    // If the bot is guarding a position, return to that position
    const pos = startingLocation.split(' ');

    bot.pathfinder.setGoal(new GoalNear(pos[0], pos[1], pos[2], 1));
  })

  // Check for new enemies to attack
  bot.on('physicsTick', () => {
    // Only look for mobs within 16 blocks
    const filter = e => e.type === 'mob' && e.position.distanceTo(bot.entity.position) < 16 &&
      e.displayName !== 'Armor Stand' // Mojang classifies armor stands as mobs for some reason?

    const entity = bot.nearestEntity(entity => {
      return entity.type === 'hostile' && entity.position.distanceTo(bot.entity.position) < 16
    });

    if (entity) {
      // Start attacking
      bot.pvp.attack(entity)
    }
  })

  bot.on('end', () => {
    console.log("Bot ended");

    // restart the bot
    setTimeout(() => {
      const bot = createBot();
      setLookInterval(bot);
    }, 2000);
  });

  bot.on('error', (err) => {
    console.log("Bot error: " + err);
  });

  return bot
}

// Look at the closest player
function setLookInterval(mybot) {
  const lookInterval = setInterval(() => {
    const playerDistance = new Map();
    for (const player in mybot.players) {
      // ignore our own player
      if (player === mybot.username) continue

      // there might not be an entity for the player yet
      if (mybot.players[player].entity === undefined) continue

      // only look at players within 5 blocks
      if (mybot.players[player].entity.position.distanceTo(mybot.entity.position) < 5) {
        playerDistance.set(player, mybot.players[player].entity.position.distanceTo(mybot.entity.position));
      }
    }

    if (playerDistance.size === 0) {
      return;
    }

    // find the closest player and look at them
    const items = Array.from(playerDistance.entries());
    items.sort((a, b) => a[1] - b[1]);

    mybot.lookAt(mybot.players[items[0][0]].entity.position.offset(0, 1.6, 0));
  }, 2000);
}

function splitStringByWordFixedLength(str, maxLength) {
  if (!str || str.length === 0 || maxLength <= 0) {
    return []; // Handle empty strings or invalid maxLength
  }

  const words = str.split(' '); // Split the string into an array of words
  const result = [];
  let currentLine = '';

  for (const word of words) {
    if (currentLine.length === 0) {
      currentLine = word; // Initialize the first word
    } else if ((currentLine + ' ' + word).length <= maxLength) {
      currentLine += ' ' + word; // Add the word to the current line if it fits
    } else {
      result.push(currentLine); // Push the current line to the result
      currentLine = word; // Start a new line with the current word
    }
  }

  // Add the last line to the result
  if (currentLine.length > 0) {
    result.push(currentLine);
  }

  return result;
}

const bot = createBot();
setLookInterval(bot);