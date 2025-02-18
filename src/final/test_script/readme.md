

```
sh /workshop/src/final/test_script/sko-test.sh \
  --team-name testorgs \
  --minecraft-hostname "debian.lsljvsplaxws.instruqt.io" \
  --minecraft-usernames '["SimonHashi"]' \
  --team-password '............'
```


export TEAM_NAME=testorgs
vault login -ns=admin -method=userpass username="${TEAM_NAME}" password='........'
vault kv get -ns=admin/${TEAM_NAME} -field=ssh-unsigned-private-key secrets/aap