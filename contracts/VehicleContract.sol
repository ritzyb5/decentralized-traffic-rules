pragma solidity ^0.4.11;//defines the version which must be supported by the compiler
//can't be compiled by a complier over v0.5

// VehicleContract is used to manage vehicles, sensor data, and tickets
//

contract VehicleContract {
	// uint public vin;  // Vehicle ID Number
	mapping(address => Vehicle) registeredVehicles;
	mapping(address => Sensor) sensors;
	event TicketAdded(uint time, address vehicleID, address sensorID, uint measuredSpeed);
	event TicketPayed(uint time, address vehcileID, uint amount);
	uint ticketNumber;

	// Structures: Vehicle, city sensors, tickets

	struct Vehicle {
		string ownerName;
		uint[] ticketIds;
		mapping(uint => Ticket) pendingTickets;
	}

	struct Sensor {
		uint speedLimit;
	}

	struct Ticket {
		uint tid;	// ticket number
		address vin;
		address sid;
		uint speed;
		uint256 time;
	}

	function VehicleContract() public {
		ticketNumber = 1;
	}

	// Function: Register vehicle, check speed (sensor), give ticket (sensor), pay ticket

	function registerVehicle(string name) public {
		registeredVehicles[msg.sender] = Vehicle(name, new uint[](0));//new Ticket[](0)
	}

	function displayVehicleName(address vid) public view returns (string){
		Vehicle storage v = registeredVehicles[vid];
		return (v.ownerName);
	}

	function displayVehicleTickets(address vid) public view returns (uint[]){
		Vehicle storage v = registeredVehicles[vid];
		return (v.ticketIds);
	}


	function addSensor(uint speed) public {
		sensors[msg.sender] = Sensor(speed);
	}

	function checkSpeed(address vid, uint measuredSpeed) public {
		/* require(); */
		if (measuredSpeed > sensors[msg.sender].speedLimit) {
			giveTicket(vid, msg.sender, measuredSpeed);
			//TicketAdded(now, vid, msg.sender, measuredSpeed);
		}
	}

	function giveTicket(address vid, address sid, uint measuredSpeed) public {
		TicketAdded(now, vid, msg.sender, measuredSpeed);
		registeredVehicles[vid].pendingTickets[ticketNumber] = Ticket(ticketNumber, vid, sid, measuredSpeed, now);
		registeredVehicles[vid].ticketIds.push(ticketNumber);
		ticketNumber++;
	}

	function payTicket(uint ticketId, address receiver) payable public{
		/* require(msg.value>=1 ether); */
		uint change=0;
		receiver.transfer(msg.value);

		/* if(msg.value>1){
			change = msg.value-1;
			msg.sender.transfer(change);
		} */
		delete registeredVehicles[msg.sender].pendingTickets[ticketId];
		delete registeredVehicles[msg.sender].ticketIds[ticketId];

		TicketPayed(now, msg.sender, msg.value);
	}
	// Need to:
}
