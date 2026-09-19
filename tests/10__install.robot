*** Settings ***
Library     SSHLibrary
Resource    api.resource

*** Variables ***
# No real foundryvtt.com account in CI: the container cannot download Foundry,
# so the suite checks the module plumbing (configuration, secrets, backup and
# restore), not the application itself.
${CONFIG}    {"host":"foundry.ci.test","lets_encrypt":false,"http2https":true,"auth_method":"credentials","foundry_username":"ci-user","foundry_password":"Foundry#Pass 1","admin_key":"Admin Key#1","license_key":"AAAA-BBBB-CCCC-DDDD-EEEE-FFFF","foundry_version":"","timezone":"Europe/Berlin"}

*** Test Cases ***
Install the module
    IF    '${SCENARIO}' == 'update'
        ${output}  ${rc} =    Execute Command    add-module ${UPDATE_FROM} 1    return_rc=True
    ELSE
        ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1    return_rc=True
    END
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Global Variable    ${module_id}    ${output.module_id}

Configure the module
    Run task    module/${module_id}/configure-module    ${CONFIG}    decode_json=${FALSE}

Update to the image under test
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}
    Run on node    api-cli run update-module --data '{"force":true,"module_url":"${IMAGE_URL}","instances":["${module_id}"]}'

Configuration reads back
    ${cfg} =    Run task    module/${module_id}/get-configuration    {}
    Should Be Equal    ${cfg['host']}    foundry.ci.test
    Should Be Equal    ${cfg['auth_method']}    credentials
    Should Be True    ${cfg['admin_key_set']}
    Should Be True    ${cfg['foundry_password_set']}
    Should Be True    ${cfg['license_key_set']}

The container receives the secrets
    ${out} =    Wait Until Keyword Succeeds    30 times    10 seconds
    ...    Run on node    runagent -m ${module_id} podman inspect foundryvtt-app --format '{{range .Config.Env}}{{println .}}{{end}}'
    Should Contain    ${out}    FOUNDRY_ADMIN_KEY=Admin Key#1
    Should Contain    ${out}    FOUNDRY_PASSWORD=Foundry#Pass 1

Secrets are stored in passwords.env only
    Secrets are kept out of the module environment    ${module_id}
