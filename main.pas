// bahasa old untuk semua kalangan
// masih dipake sampe sekarang
// yg ga pernah coba semoga kentutnya berdahak
program aibego;
{$warnings off}
{$mode delphi}
uses
    SysUtils, Classes, fphttpclient, fpjson, jsonparser, opensslsockets;

function SendRequest(const inputText: string): string;
var
    client: TFPHTTPClient;
    response: string;
    jsonData: TJSONData;
    jsonResponse: TJSONObject;
    postData: TStringList;
begin
    client := TFPHTTPClient.Create(nil);
    postData := TStringList.Create;
    try
        client.AddHeader('Content-Type', 'application/x-www-form-urlencoded');
        postData.Add('text=' + inputText);
        postData.Add('lc=id');
        response := client.FormPost('https://api.simsimi.vn/v1/simtalk', postData);

        jsonData := GetJSON(response);
        if jsonData.JSONType = jtObject then
        begin
            jsonResponse := TJSONObject(jsonData);
        if jsonResponse.Find('message') <> nil then
            Result := jsonResponse.Strings['message']
        else
            Result := 'err get respon';
        end
        else
            Result := 'ror parsing';
    finally
        client.Free;
        postData.Free;
    end;
end;

var
    inputText: string;
    responseMessage: string;
begin
    while True do
    begin
        Write('you>: ');
        ReadLn(inputText);

        if inputText = 'exit' then
        begin
        WriteLn('quitt...');
        Break;
        end;

        responseMessage := SendRequest(inputText);
        WriteLn('bot>: ', responseMessage);
    end;
end.
