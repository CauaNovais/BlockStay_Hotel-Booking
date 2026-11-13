// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HotelBooking {

    // The info about each hotel
    struct Hotel {
        uint256 id;
        string name;
        address owner;
    }

    // The info about each reservation
    struct Booking {
        uint256 id;
        uint256 hotelId;
        address customer;
        address hotelOwner; //the hotel owner in the info
        uint256 roomNumber;
        uint256 checkIn;
        uint256 checkOut;
        bool active;
    }

    // Store hotels and bookings
    mapping(uint256 => Hotel) public hotels;
    mapping(uint256 => Booking) public bookings;

    // Keep track of registered hotels and bookings
    uint256 public hotelCount;
    uint256 public bookingCount;

    // Registration of a new hotel
    function registerHotel(string memory _name) public {
        require(bytes(_name).length > 0, "Hotel name required");

        hotelCount++;

        hotels[hotelCount] = Hotel({
            id: hotelCount,
            name: _name,
            owner: msg.sender //store the blockchain address
        });
    }

    // Create a new hotel reservation
    function makeBooking(
        uint256 _hotelId,
        uint256 _roomNumber,
        uint256 _checkIn,
        uint256 _checkOut
    ) public returns (uint256){

    // Check if the hotel exists
        require(_hotelId > 0 && _hotelId <= hotelCount,"Hotel does not exist");

    // Check if the dates are valid
        require(_checkIn >= block.timestamp,"Check-in date must be in the future"); //current time recorded by the blockchain

        require(_checkOut > _checkIn,"Invalid booking dates");

    // Check if the room is already booked
        for (uint256 i = 1; i <= bookingCount; i++){

        Booking memory existing = bookings[i];

        if (existing.active && existing.hotelId == _hotelId && existing.roomNumber == _roomNumber){
            require(_checkIn >= existing.checkOut || _checkOut <= existing.checkIn, "Room already booked for these dates"); //dates overlap
        }
    }

    // Create the booking
    bookingCount++;

    bookings[bookingCount] = Booking({
        id: bookingCount,
        hotelId: _hotelId,
        customer: msg.sender,
        hotelOwner: hotels[_hotelId].owner, //retrieves the hotel owner's address from the hotel registration info
        roomNumber: _roomNumber,
        checkIn: _checkIn,
        checkOut: _checkOut,
        active: true
    });

    return bookingCount;
    }

    // Cancel an existing reservation
    function cancelBooking(uint256 _bookingId) public{

        require(_bookingId > 0 && _bookingId <= bookingCount,"Booking does not exist");

        Booking storage booking = bookings[_bookingId];

    // Only the customer who made the booking can cancel it
        require(booking.customer == msg.sender,"Only the customer can cancel");

        require(booking.active, "Booking already cancelled");

        booking.active = false;
    }

    // Retrieve booking information
    function getBooking(uint256 _bookingId) public view returns (Booking memory){

        require(_bookingId > 0 && _bookingId <= bookingCount,"Booking does not exist");

        return bookings[_bookingId];
    }
}