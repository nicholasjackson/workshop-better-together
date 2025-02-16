#!/bin/sh

# Parse command line arguments
while [ $# -gt 0 ]; do
    case $1 in
        --team-name)
            TEAM_NAME="$2"
            shift 2
            ;;
        --minecraft-hostname)
            MINECRAFT_HOSTNAME="$2"
            shift 2
            ;;
        --minecraft-usernames)
            MINECRAFT_USERNAMES="$2"
            shift 2
            ;;
        --team-password)
            TEAM_PASSWORD="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# Validate required inputs
if [ -z "$TEAM_NAME" ] || [ -z "$MINECRAFT_HOSTNAME" ] || [ -z "$MINECRAFT_USERNAMES" ] || [ -z "$TEAM_PASSWORD" ]; then
    echo "Error: Missing required parameters"
    echo "Usage: sh $0 --team-name <name> --minecraft-hostname <hostname> --minecraft-usernames <usernames> --team-password <password>"
    echo "Example: sh $0 --team-name testorgz --minecraft-hostname 'debian.yhjrgxniz0wk.instruqt.io' --minecraft-usernames '[\"SherrifJackson\"]' --team-password 'Hashicorp123!sko2025'"
    exit 1
fi

SECONDS=0
export TEAM_NAME
export MINECRAFT_HOSTNAME
export MINECRAFT_USERNAMES
export TEAM_PASSWORD
export TF_VAR_vault_namespace=admin/$TEAM_NAME
export MINECRAFT_HOSTNAME_GCP="sko-minecraft.hashicraft.com"

LIGHT_COLOR='\033[1;33m' # Yellow
COLOR='\033[0;35m' # Purple
ERROR_COLOR='\031[0;35m' # Red
NC='\033[0m' # No Color
echo -e "${COLOR}Starting Testing of Bettter Together Workshop${NC}"
echo -e "${COLOR}Getting AAP auth token{NC}"

TOKEN=$(curl -X POST -k "https://44.210.128.100/api/gateway/v1/tokens/" \
     -u "${TEAM_NAME}_admin":'Hashicorp123!sko2025' \
     -H "Content-Type: application/json" | jq -r '.token')
echo "Token: $TOKEN"

# Task 1a - Step 1 - Terraform intital deployment
#check if aap already exists - task 3 has been completed
if [ -f "/workshop/src/working/terraform/aap.tf" ]; then
    echo "aap.tf already exists. Skipping Task 1 - Terraform..."
else
    echo "Task 1 - Terraform - Proceeding..."
    echo -e "${LIGHT_COLOR}Task1a-Step1-Terraform Terraform apply started${NC}"

    cd /workshop/src/working/terraform
    terraform init
    terraform apply -auto-approve
    echo -e "${LIGHT_COLOR}Task1a-Step1-Terraform apply completed${NC}"
    sleep 5
fi


if [ -d "/var/workshop/images/minecraft_vm_ansible" ]; then
  echo -e "${LIGHT_COLOR}Task3-Step1-Packer - Skipped${NC}"
  echo "image already exists. Skipping Task 3 Step 1 - Packer..."
else
  # Task 3 - Step 1 - packer build
  echo -e "${LIGHT_COLOR}Task3-Step1-Packer  started${NC}"
  cd /workshop/src/working/packer
  packer init .
  echo -e "${LIGHT_COLOR}Task3-Step1-Packer  init completed ${NC}"
  sleep 1

  packer build -var vault_namespace="${TEAM_NAME}" .
  echo -e "${LIGHT_COLOR}Task3-Step1-Packer  build completed ${NC}"
  sleep 1
fi

# Task 3 - Step 2 - Terraform
cd /workshop/src/working/terraform

cp ../aap/* .
ls

echo -e "${LIGHT_COLOR}Task3-Step2-Terraform started ${NC}"
# Task 3 - Step 2 - Terraform variables
terraform init
terraform validate
# Task 3 - Step 2 - execute if no errors check std errors
if [ $? -eq 0 ]; then
  terraform apply -auto-approve \
  -var "aap_username=${TEAM_NAME}_admin" \
  -var "aap_password=${TEAM_PASSWORD}" \
  -var "minecraft_hostname=${MINECRAFT_HOSTNAME}" \
  -var "minecraft_usernames="${MINECRAFT_USERNAMES}""

  echo -e "${LIGHT_COLOR} checking AAP job status - $(terraform output aap_job_url)"
  sleep 45
  export AAP_JOB_URL=$(terraform output aap_job_url | xargs)/
  export AAP_JOB_URL_TXT=$(terraform output aap_job_url | xargs)stdout/?format=txt_download
  echo $AAP_JOB_URL
  # checking AAP result getting std out for job execution

  AAP_STATUS_TASK3=$(curl -k $AAP_JOB_URL \
  -H "Authorization: Bearer $TOKEN" \
  | jq -r '.status')

  if [ $AAP_STATUS_TASK3 == "successful" ]; then
    echo -e "${LIGHT_COLOR}Task3-Step2-AAP job successful ${NC}" 
  else
    echo -e "${ERROR_COLOR}Task3-Step2-AAP job not successful ${NC}"
    echo $AAP_STATUS_TASK3
  fi

  curl -k $AAP_JOB_URL_TXT \
     -H "Authorization: Bearer $TOKEN" \
     -o task3-aap-response.txt
  sleep 3
  echo -e "${LIGHT_COLOR}Task3-Step2-AAP job output ${NC}"
  cat task3-aap-response.txt

  echo -e "${LIGHT_COLOR}Task3-Step2-Getting AAP StdOut for job execution ${NC}"
  echo -e "${LIGHT_COLOR}Task3-Step2-Terraform completed ${NC}"

else
  echo -e "${ERROR_COLOR}Task3-Step2-Terraform errors found in Terraform appl${NC}"
fi



# Task 4 - Step 1 - Terraform - Example solution
echo -e "${LIGHT_COLOR}Task4-Step1-Terraform started - Example solution ${NC}"
if [ $? -eq 0 ]; then
  cd /workshop/src/final/task_4/example_solution/
  terraform init
  terraform apply -auto-approve \
  -var "aap_username=${TEAM_NAME}_admin" \
  -var "aap_password=${TEAM_PASSWORD}" \
  -var "minecraft_hostname=${MINECRAFT_HOSTNAME_GCP}" \
  -var "minecraft_usernames="${MINECRAFT_USERNAMES}""

  echo -e "${LIGHT_COLOR}Task4-Step1-sleeping 15s for job to complete ${NC}"
  sleep 15

  echo -e "${LIGHT_COLOR}Task4-Step1-rerun to check job status on output ${NC}"

  terraform apply -auto-approve \
  -var "aap_username=${TEAM_NAME}_admin" \
  -var "aap_password=${TEAM_PASSWORD}" \
  -var "minecraft_hostname=${MINECRAFT_HOSTNAME_GCP}" \
  -var "minecraft_usernames="${MINECRAFT_USERNAMES}""

  echo -e "${LIGHT_COLOR}Task4-Step1-Terraform completed ${NC}"
  echo -e "${LIGHT_COLOR} checking AAP job status - $(terraform output aap_job_url)"
  export AAP_JOB_URL2_TXT=$(terraform output aap_job_url | xargs)stdout/?format=txt
  echo $AAP_JOB_URL2=$(terraform output aap_job_url | xargs)/
  # checking AAP result getting std out for job execution
  sleep 30

  AAP_STATUS_TASK4=$(curl -k $AAP_JOB_URL2 \
  -H "Authorization: Bearer $TOKEN" \
  | jq -r '.status')

   if [ $AAP_STATUS_TASK4 == "successful" ]; then
    echo -e "${LIGHT_COLOR}Task4-Step1-AAP job successful ${NC}" 
  else
    echo -e "${ERROR_COLOR}Task4-Step1-AAP job not successful ${NC}"
    echo $AAP_STATUS_TASK4
  fi

  curl -k $AAP_JOB_URL_TXT \
    -H "Authorization: Bearer $TOKEN" \
    -o task4-aap-response.txt
  sleep 3
  echo -e "${LIGHT_COLOR}Task4-Step1-AAP job output ${NC}"
  cat task4-aap-response.txt

else 
  echo -e "${ERROR_COLOR}Task4-Step1-Skipped due to previous errors found{NC}"
fi


# Print runtime
duration=$SECONDS
echo "Script took -- $duration -- seconds to complete"



## Cleanup

read -p "Do you want to perform cleanup? (y/n): " answer

case $answer in
    [Yy]* )
        echo "Starting cleanup..."
        ## Task 3 - Terraform destroy
        cd /workshop/src/working/terraform
          terraform destroy -auto-approve \
          -var "aap_username=${TEAM_NAME}_admin" \
          -var "aap_password=${TEAM_PASSWORD}" \
          -var "minecraft_hostname=${MINECRAFT_HOSTNAME}" \
          -var "minecraft_usernames="${MINECRAFT_USERNAMES}""


        ## Task 4 - Terraform destroy
        cd /workshop/src/final/task_4/example_solution/
        terraform destroy -auto-approve \
        -var "aap_username=${TEAM_NAME}_admin" \
        -var "aap_password=${TEAM_PASSWORD}" \
        -var "minecraft_hostname=${MINECRAFT_HOSTNAME_GCP}" \
        -var "minecraft_usernames="${MINECRAFT_USERNAMES}"" \

        echo "Cleanup completed."
        ;;
    [Nn]* )
        echo "Cleanup cancelled."
        ;;
    * )
        echo "Please answer yes or no."
        ;;
esac

echo "Finished Testing"

