pragma solidity ^0.4.11;//defines the version which must be supported by the compiler
//can't be compiled by a complier over v0.5

// VehicleContract is used to manage vehicles, sensor data, and tickets
//

contract VehicleContract {
	// uint public vin;  // Vehicle ID Number
	mapping(address => Vehicle) registeredVehicles;
	mapping(address => Sensor) sensors;
	event TicketAdded(uint time, address vehicleID, address sensorID, uint measuredSpeed);
	event TicketPayed(uint time, uint ticketId, address vehcileID, uint amount);
	event ChangeReturned(uint time, uint ticketId, address vehcileID, uint amount);
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

//Function to register a vehicle
	function registerVehicle(string name) public {
		registeredVehicles[msg.sender] = Vehicle(name, new uint[](0));//new Ticket[](0)
	}

//Function to display vehicle name
	function displayVehicleName(address vid) public view returns (string){
		Vehicle storage v = registeredVehicles[vid];
		return (v.ownerName);
	}

//Function to display pending ticket ids
	function displayVehicleTickets(address vid) public view returns (uint[]){
		Vehicle storage v = registeredVehicles[vid];
		return (v.ticketIds);
	}

//Function to display ticket details for a particluar vehicle and ticketid
	function displayTicketDetails(address vid, uint ticketId) public view returns(uint,address,address,uint,uint256){
		Vehicle storage v = registeredVehicles[vid];
		return (v.pendingTickets[ticketId].tid, v.pendingTickets[ticketId].vin, v.pendingTickets[ticketId].sid, v.pendingTickets[ticketId].speed, v.pendingTickets[ticketId].time);
	}

//Function to add a sensor
	function addSensor(uint speed) public {
		sensors[msg.sender] = Sensor(speed);
	}

//Function to be called by sensor to check speed of passing vehicle
	function checkSpeed(address vid, uint measuredSpeed) public {

		if (measuredSpeed > sensors[msg.sender].speedLimit) {
			giveTicket(vid, msg.sender, measuredSpeed);
		}
	}

//Function to give a speeding vehicle a ticket.
//To be called by the sensor
	function giveTicket(address vid, address sid, uint measuredSpeed) public {
		TicketAdded(now, vid, msg.sender, measuredSpeed);
		registeredVehicles[vid].pendingTickets[ticketNumber] = Ticket(ticketNumber, vid, sid, measuredSpeed, now);
		registeredVehicles[vid].ticketIds.push(ticketNumber);
		ticketNumber++;
	}

//Function to pay a ticket
//To be called by Vehicle
	function payTicket(uint ticketId, address receiver) payable public{
		require(msg.value>=1 ether);
		/* uint change=0;


		if(msg.value>1 ether){
			change = msg.value-1;
			msg.sender.transfer(change);
			ChangeReturned(now, ticketId, msg.sender, change);
		} */
		receiver.transfer(msg.value);
		delete registeredVehicles[msg.sender].pendingTickets[ticketId];
		delete registeredVehicles[msg.sender].ticketIds[ticketId];

		TicketPayed(now, ticketId, msg.sender, msg.value);
	}

}
