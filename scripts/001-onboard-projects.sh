# Define the array of new GDC Project IDs you want to create.
declare -a NEW_PROJECT_IDS=(
    "L1-project-1"
    "L1-project-1"
    "L1-project-1"
    "test-environment-01"
)

# --- 2. EXECUTION LOOP ---

echo "🚀 Starting creation of ${#NEW_PROJECT_IDS[@]} GDC Projects..."
echo "--------------------------------------------------------"

for PROJECT_ID in "${NEW_PROJECT_IDS[@]}"; do
    echo "Attempting to create project: **$PROJECT_ID**"

    # The gdcloud command to create a project
    # The --quiet flag suppresses interactive prompts.
    gdcloud projects create "$PROJECT_ID" \
        --name="$PROJECT_ID" \
        --quiet

    if [ $? -eq 0 ]; then
        echo "Success: Project $PROJECT_ID created."
    else
        echo "Failure: Could not create $PROJECT_ID. Check permissions or project name availability."
    fi
    echo ""
done

echo "Script finished."