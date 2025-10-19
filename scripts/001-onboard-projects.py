#!/usr/bin/env python3
import yaml
import subprocess

def main():

    print("🚀 Starting creation of ${#NEW_PROJECT_IDS[@]} GDC Projects...")
    print("--------------------------------------------------------")
    
    """
    Main function to onboard projects.
    """
    # Assuming projects.yaml is in a config directory parallel to scripts
    with open("../config/projects.yaml", "r", encoding="utf-8") as stream:
        try:
            data = yaml.safe_load(stream)
            if "projects" in data and data["projects"]:
                print("Checking for existing projects...")
                for project in data["projects"]:
                    if "name" in project:
                        project_name = project["name"]
                        command = ["gdcloud", "projects", "describe", project_name]
                        result = subprocess.run(
                            command, capture_output=True, text=True, check=False
                        )

                        if result.returncode == 0:
                            print(f"- Project '{project_name}' already exists.")
                        else:
                            print(f"- Project '{project_name}' does not exist. Creating...")
                            create_command = [
                                "gdcloud",
                                "projects",
                                "create",
                                project_name,
                                "--display-name",
                                project.get("displayName", project_name),
                                "--description",
                                project.get("description", ""),
                            ]
                            create_result = subprocess.run(
                                create_command, capture_output=True, text=True, check=False
                            )
                            if create_result.returncode == 0:
                                print(f"  - Successfully created project '{project_name}'.")
                            else:
                                print(f"  - Failed to create project '{project_name}'.")
                                print(f"    Error: {create_result.stderr.strip()}")
            else:
                print("No projects found under the 'projects' key.")
        except yaml.YAMLError as exc:
            print(f"Error parsing YAML file: {exc}")

if __name__ == "__main__":
    main()