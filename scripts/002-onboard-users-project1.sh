# Define your Sandbox Project ID
PROJECT_ID="your-L1-project-id"

IDP_PREFIX="fop"

# Define the 5 GDC users (their email addresses)
declare -a USERS=(
    "user1@example.com"
    "user2@example.com"
    "user3@example.com"
    "user4@example.com"
    "user5@example.com"
)

#  Define the GDC roles you want to assign. 
# (You can use predefined roles like the examples below, or your own custom roles.)
declare -a ROLES=(
    "roles/project-viewer"         # e.g., Viewer
    "roles/project-admin"          # e.g., Project Admin
    "roles/cloudbuild.builds.editor" # e.g., Build Editor
    "roles/logging.viewer"         # e.g., Log Viewer
)


echo "Starting role assignment for 5 users in project: $PROJECT_ID"
echo "--------------------------------------------------------"

for i in "${!USERS[@]}"; do
    USER_EMAIL="${USERS[$i]}"
    ROLE_ID="${ROLES[$i]}"
    MEMBER_ID="user:$IDP_PREFIX-$USER_EMAIL"

    echo "Attempting to assign $ROLE_ID to $USER_EMAIL..."

    # The actual gdcloud command for role assignment
    gdcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --role="$ROLE_ID" \
        --member="$MEMBER_ID" \
        --quiet
        
    if [ $? -eq 0 ]; then
        echo " Success: $USER_EMAIL now has the $ROLE_ID role."
    else
        echo " Failure: Could not assign $ROLE_ID to $USER_EMAIL."
    fi
    echo ""
done

echo "Script finished."
