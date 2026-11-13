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
}