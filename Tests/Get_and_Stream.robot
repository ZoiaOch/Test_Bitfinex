*** Settings ***
Documentation  Tests verify the correctness of responses from httpbin.org.
Test Timeout  10

Library   String
Library   ../Library/ResponseHandler.py

*** Variables ***
${expected_status_code}=  ${200}
${amount_of_streams}=  ${5}
${expected_header_val}=  keep-alive
${httpbin_url}=  http://httpbin.org
${header}=  Connection

*** Test Cases ***
Cehck Request Header Var 1
    [Documentation]  Test verify that chosen header has an appropriate value.
    Request To Httpbin  ${httpbin_url}/get
    Check Response Status Code  ${expected_status_code}
    Check Response Header  ${header}  ${expected_header_val}

Check the Amount of Streams Var 1
    [Documentation]  Test verify that requested amount of streams corresponds to received.
    Request To Httpbin  ${httpbin_url}/stream/${amount_of_streams}
    Check Response Status Code  ${expected_status_code}
    Check Amount of Streams  ${amount_of_streams}

#Further tests represents one more possibility of using ResponseHandler library
Cehck Request Header Var 2
    [Documentation]  Test verify that chosen header has an appropriate value.
    ${request}=  Request To Httpbin  ${httpbin_url}/get
    Should Be Equal  &{request.headers}[${header}]  ${expected_header_val}
    ...  Incorrect connection header: &{request.headers}[${header}]. Should be ${expected_header_val}.
    Should Be Equal  ${request.status_code}  ${expected_status_code}
    ...  Expected status code is ${expected_status_code}, received: ${request.status_code}.

Check the Amount of Streams Var 2
    [Documentation]  Test verify that requested amount of streams corresponds to received.
    ${request}=  Request To Httpbin  ${httpbin_url}/stream/${amount_of_streams}
    ${strings_list}=  Split String  ${request.text}  \n
    ${strings_list_len}=  Get Length  ${strings_list}
    ${strings_list_len}=  Evaluate  ${strings_list_len} - 1
    Should Be Equal As Integers  ${strings_list_len}  ${amount_of_streams}
    ...  Incorrect amount of streams: ${strings_list_len}. Should be ${amount_of_streams}.
    Should Be Equal  ${request.status_code}  ${expected_status_code}
    ...  Expected status code is ${expected_status_code}, received: ${request.status_code}.