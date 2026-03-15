// Timer events
event TimerStart;
event TimerStop;
event Timeout;
event TimerTick;

machine Timer {
    var owner: machine;

    start state Init {
        entry (o: machine) {
            owner = o;
            goto Idle;
        }
    }

    state Idle {
        on TimerStart goto Running;
        ignore TimerStop, TimerTick;
    }

    // A 'hot' state in a regular machine (not just specs) can be used 
    // to model progress obligations if the checker supports it.
    // In P, we usually use this in specs, but some versions allow it in machines.
    // If not, we'll use the 'send this' loop.
    state Running {
        on TimerStop goto Idle;
        on TimerStart goto Running;
        on TimerTick goto Running;

        entry {
            if ($) {
                send owner, Timeout;
                goto Idle;
            } else {
                send this, TimerTick;
            }
        }
    }
}
