//cb_T1_SelfPlayerInfo()
var _connectionId  = argument0;
var _receivedData  = argument1;

var _username = _receivedData[0]; //buffer_string
var _character = _receivedData[1]; //buffer_u8

var _client = fGetClientById(_connectionId)

with (_client)
{
	m_username = _username
	m_character = _character
}
