#!/usr/bin/env python3
import yaml
import subprocess
import os
import sys


def main():
    """
    Main function to create Harbor projects based on a config file.
    """
    print("🚀 Starting creation of Harbor projects...")
    print("-------------------------------------------")

    # Construct the path to the config file
    script_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(script_dir, "projects_config.yaml")

    try:
        with open(config_path, "r", encoding="utf-8") as stream:
            data = yaml.safe_load(stream)
    except FileNotFoundError:
        print(f"Error: Configuration file not found at {config_path}", file=sys.stderr)
        sys.exit(1)
    except yaml.YAMLError as exc:
        print(f"Error parsing YAML file: {exc}", file=sys.stderr)
        sys.exit(1)

    # --- Harbor Configuration from YAML ---
    harbor_config = data.get("config", {}).get("harbor", {})
    harbor_instance = harbor_config.get("instance")
    harbor_instance_project = harbor_config.get("project")

    if not all([harbor_instance, harbor_instance_project]):
        print("Error: 'harbor.instance' and 'harbor.project' must be defined in the 'config' section of the YAML.", file=sys.stderr)
        sys.exit(1)

    print(f"Using Harbor Instance: '{harbor_instance}' in project '{harbor_instance_project}'")

    projects = data.get("projects")
    if not projects:
        print("No projects found in the config file.", file=sys.stderr)
        sys.exit(1)

    for project in projects:
        project_name = project.get("name")
        if not project_name:
            continue

        print(f"Processing Harbor project: '{project_name}'")

        # 1. Check if the Harbor project already exists
        check_command = [
            "gdcloud", "harbor", "harbor-projects", "describe", project_name,
            "--instance", harbor_instance,
            "--project", harbor_instance_project
        ]
        check_result = subprocess.run(check_command, capture_output=True, text=True, check=False)

        if check_result.returncode == 0:
            print(f"  - Harbor project '{project_name}' already exists.")
            continue

        # 2. If not, create the Harbor project
        print(f"  - Harbor project '{project_name}' does not exist. Creating...")
        create_command = [
            "gdcloud", "harbor", "harbor-projects", "create", project_name,
            "--instance", harbor_instance,
            "--project", harbor_instance_project
        ]
        create_result = subprocess.run(create_command, capture_output=True, text=True, check=False)

        if create_result.returncode == 0:
            print(f"  - Successfully created Harbor project '{project_name}'.")
        else:
            # Check for a specific error indicating it already exists, in case of a race condition
            if "already exists" in create_result.stderr:
                print(f"  - Harbor project '{project_name}' already exists.")
            else:
                print(f"  - Failed to create Harbor project '{project_name}'.")
                print(f"    Error: {create_result.stderr.strip()}")

if __name__ == "__main__":
    main()
