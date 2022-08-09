import requests
import json
from distutils.command.config import config
import os
import ruamel.yaml

event_type = os.getenv("EVENT_TYPE")
repository = os.getenv("REPOSITORY")  # artifact registry
image_tag = os.getenv("IMAGE_TAG")
from_branch = os.getenv("FROM_BRANCH")
into_branch = os.getenv("INTO_BRANCH")
gh_repository = os.getenv("GH_REPOSITORY")
personal_access_token = os.getenv("PERSONAL_ACCESS_TOKEN")
chart_dir = os.getenv("CHART_DIR")


def trigger_update_event(chart_version=None):

    print("Trigger PR approval...")

    if event_type == "update-chart":

        client_payload = {
            "event_type": "update-chart",
            "client_payload": {
                "chart_version": chart_version,
                "image_tag": image_tag,
                "artifact_repository": repository,
                "into_branch": "staging"
            }
        }

    elif event_type == "approve-pr":

        client_payload = {
            "event_type": "approve-pr",
            "client_payload": {
                "from_branch": from_branch,
                "into_branch": into_branch
            }
        }

    # TODO: change to Federato project
    res = requests.post(
        f"https://api.github.com/repos/Federato/{gh_repository}/dispatches",

        headers={
            "Accept": "application/vnd.github.everest-preview+json",
            "Content-Type": "application/json",
            "Authorization": f"Bearer {personal_access_token}"
        },

        data=json.dumps(client_payload)
    )

    print(client_payload)
    print(res.status_code)


def update_chart_values(chart_dir):

    file_name = f'{chart_dir}/Chart.yaml'
    values_config, ind, bsi = ruamel.yaml.util.load_yaml_guess_indent(
        open(file_name))

    chart_version = values_config['version']
    trigger_update_event(chart_version)


if event_type == "update-chart":
    chart_dirs = chart_dir.split(" ")

    for dir in chart_dirs:
        update_chart_values(dir)

elif event_type == "approve-pr":
    trigger_update_event()
