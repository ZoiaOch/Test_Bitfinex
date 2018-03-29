*** Settings ***
Documentation     Tests verify that httpbin.org returns the appropriate
...               status code on different combinations of login and password. \n\n
...               The correct login and password are "user" and "passwd" respectively. \n\n
...               Tests' table:
...               | *Test*                              | *Login*     | *Password*     | *Expected Status Code* |
...               | Valid Login and Valid Password      | valid login | valid password |          200           |
...               | Invalid Login and Valid Password    | some        | valid password |          401           |
...               | Valid Login and Invalid Password    | valid login | some           |          401           |
...               | Invalid Login and Invalid Password  | some        | some           |          401           |
...               | Empty Login and Invalid Password    | EMPTY       | some           |          401           |
...               | Space Login and Invalid Password    | SPACE       | some           |          401           |
...               | Valid Login and Empty Password      | some        | EMPTY          |          401           |
...               | Valid Login and Space Password      | some        | SPACE          |          401           |
...               | Empty Login and Empty Password      | EMPTY       | EMPTY          |          401           |
...               | Space Login and Space Password      | SPACE       | SPACE          |          401           |
...               | Empty Login and Space Password      | EMPTY       | SPACE          |          401           |
...               | Space Login and Empty Password      | SPACE       | EMPTY          |          401           |
...               | Valid Login and Large Password      | valid login | large password |          401           |
...               | Large Login and Valid Password      | large login | valid password |          401           |
...               | Large Login and Large Password      | large login | large password |          401           |
...               | Rus Login and Valid Password        | rus login   | valid password |          401           |
...               | Valid Login and Rus Password        | valid login | rus password   |          401           |
...               | Rus Login and Rus Password          | rus login   | rus password   |          401           |
Test Template  Cehck Authorization Status Code
Test Timeout  10

Library  ../Library/ResponseHandler.py

*** Variables ***
${valid_password}=  passwd
${large_password}=  fhd;giuwhgpicdhaugfh;reopIOHIEH:WI&^&^*#^%@)*0--254wrtghn(&#!@#$%^&*()_+/,.'\[puk.';l.[preeuqpbnvb>?|"{FPOSFIUPvmv
${rus_password}=  пароль
${valid_login}=  user
${large_login}=  fdjklghsdfi!!@#$%^&*()__@uwr9852kh*&*O$#YHJNFeijdur<>?"||}{:'\/.,y98tpwih45ni;uHBKJG:E(%IU#)_Q{R-fodklg;ks
${rus_login}=  логин
${auth_url}=  http://httpbin.org/basic-auth/user/passwd

*** Test Cases ***                    Login                  Password                   Expected Status Code
Valid Login and Valid Password        ${valid_login}         ${valid_password}          ${200}
Invalid Login and Valid Password      some                   ${valid_password}          ${401}
Valid Login and Invalid Password      ${valid_login}         some                       ${401}
Invalid Login and Invalid Password    some                   some                       ${401}
Empty Login and Invalid Password      ${EMPTY}               some                       ${401}
Space Login and Invalid Password      ${SPACE}               some                       ${401}
Valid Login and Empty Password        some                   ${EMPTY}                   ${401}
Valid Login and Space Password        some                   ${SPACE}                   ${401}
Empty Login and Empty Password        ${EMPTY}               ${EMPTY}                   ${401}
Space Login and Space Password        ${SPACE}               ${SPACE}                   ${401}
Empty Login and Space Password        ${EMPTY}               ${SPACE}                   ${401}
Space Login and Empty Password        ${SPACE}               ${EMPTY}                   ${401}
Valid Login and Large Password        ${valid_login}         ${large_password}          ${401}
Large Login and Valid Password        ${large_login}         ${valid_password}          ${401}
Large Login and Large Password        ${large_login}         ${large_password}          ${401}
Rus Login and Valid Password          ${rus_login}           ${valid_password}          ${401}
Valid Login and Rus Password          ${valid_login}         ${rus_password}            ${401}
Rus Login and Rus Password            ${rus_login}           ${rus_password}            ${401}

*** Keywords ***
Cehck Authorization Status Code
    [Arguments]  ${login}  ${password}  ${expected_status_code}
    ${data}=  Create List  ${login}  ${password}
    Request To Httpbin  ${auth_url}  ${data}
    Check Response Status Code  ${expected_status_code}