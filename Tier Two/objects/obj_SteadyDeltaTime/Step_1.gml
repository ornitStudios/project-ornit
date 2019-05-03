/// @description  Manage Delta Timing Update

// Store previous internal delta time
dtPrevious = dt;
// Update internal delta time
dt = delta_time;
// Set raw unsteady delta time affected by time s
global.dt_unsteady = dt*scale;

global.dtCounter[deltaCounter.server] += global.dt_unsteady

// Prevent delta time from exhibiting sporadic behaviour
if (dt > 1/minFPS * ONE_MILLION)
{
    if (dtRestored) 
    { 
        dt = 1/minFPS * ONE_MILLION; 
    } 
    else 
    { 
        dt = dtPrevious;
        dtRestored = true;
    }
}
else
{
    dtRestored = false;
}

// Assign internal delta time to global delta time affected by the time scale
global.dt_steady = dt*scale;

var _server = global.dtCounter[deltaCounter.server] / ONE_MILLION 
var _client = global.dtCounter[deltaCounter.client] / ONE_MILLION

f_ConsoleAddMessage("serverDeltaTime:ClientDeltaTime " + string(_server) + ":" + string(_client))
