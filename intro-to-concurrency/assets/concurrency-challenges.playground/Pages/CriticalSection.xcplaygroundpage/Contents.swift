import Foundation


// Identify the critical section

func sleepOnTheBed() {}
var roomIsAvailable = true

// Enter if the room is available
if (roomIsAvailable) {
    // Room is ocupado
    roomIsAvailable = false
    sleepOnTheBed()
    roomIsAvailable = true
} else {
    // Room is not available, wait or do something else
}













