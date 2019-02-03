/// cb_ServerRecieveClientImputs()
var _time = current_time //do this first to get most accurate time
var _connectionId  = argument0;
var _receivedData  = argument1;

var _hMove = _receivedData[0]; //buffer_s8
var _vMove = _receivedData[1]; //buffer_s8
var _packetNumber = _receivedData[2] //buffer_u64 packet number

var _client = fGetClientById(_connectionId)

if (_client == noone)
{
	show_error("The Server recieved an imput packet from a player that does not exist /n Connection ID : " + string(_connectionId),false)
	return;
}
else
{
	with (_client)
	{
		if (_packetNumber > m_latestRecievedPacket) //drop older packets
		{
			hsp = _hMove * walksp;
			vMove = _vMove;
			m_latestRecievedPacket = _packetNumber
		}
	}
}