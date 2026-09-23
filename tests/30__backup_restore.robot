*** Settings ***
Library     SSHLibrary
Resource    api.resource

*** Test Cases ***
Seed a probe file
    Run on node    runagent -m ${module_id} podman run --rm --volume foundryvtt-data:/data:z docker.io/library/alpine:3.20 sh -c 'echo pre-backup > /data/ci_probe.txt'

Back up the module
    ${repo}    ${path} =    Back up the module to the cluster repository    ${module_id}
    Set Global Variable    ${BACKUP_REPO}    ${repo}
    Set Global Variable    ${BACKUP_PATH}    ${path}

Restore into a new instance
    ${rid} =    Restore the module from the cluster repository    ${BACKUP_REPO}    ${BACKUP_PATH}
    Set Global Variable    ${restored_id}    ${rid}
    Should Not Be Equal    ${restored_id}    ${module_id}

The restored instance has data, settings and secrets
    ${out} =    Run on node    runagent -m ${restored_id} podman run --rm --volume foundryvtt-data:/data:z docker.io/library/alpine:3.20 cat /data/ci_probe.txt
    Should Contain    ${out}    pre-backup
    ${cfg} =    Run task    module/${restored_id}/get-configuration    {}
    Should Be Equal    ${cfg['auth_method']}    credentials
    Should Be True    ${cfg['admin_key_set']}
    Should Be True    ${cfg['foundry_password_set']}
    Should Be True    ${cfg['license_key_set']}
    Secrets are kept out of the module environment    ${restored_id}
