import * as React from 'react';
import ReactDOMServer from 'react-dom/server';

import { faCheck, faLocationDot, faX } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import L from 'leaflet';
import { Circle, MapContainer, Marker, TileLayer, Popup, useMap } from 'react-leaflet'

import { LazyLoadImage } from 'react-lazy-load-image-component';

import PlaceholderImage from '../assets/placeholder.svg';

function MissingPointsCarousel(props) {
    function MapRefComponent() {
        console.log(chosenCheckIn, requests[chosenCheckIn])

        const latLngs = [requests[chosenCheckIn].eventCoordinates]
        var bounds = null;
        if (requests[chosenCheckIn].studentLoc && Object.keys(requests[chosenCheckIn].studentLoc).length > 0) {
            latLngs.push(requests[chosenCheckIn].studentLoc)
            bounds = new L.latLngBounds(...latLngs)
        } else {
            bounds = new L.latLng(latLngs[0], 100);
            bounds = bounds.toBounds(200);
        }
    
        useMap().fitBounds(bounds);
    
        console.log('bounds:', bounds);
        console.log('map center:', useMap().getCenter())
        
        return null
    }  

    const [isBlurred, setIsBlurred] = React.useState(false);

    const [requests, setRequests] = React.useState([
        // { studentName: "Brett Kaplan", studentId: "123456", event: "Allen v. North Crowley", eventCoordinates: { lat: 32.92968306464252, lng: -97.11231812644931 }, studentLoc: { lat: 33.1097, lng: -96.6608 }, eventCategory: "Football", imageURL: "https://www.oneathletic.com/cdn/shop/files/one-athletic-tracksuit-running.jpg", prevAttended: 4 },
        // { studentName: "Testing User", studentId: "123456", event: "Allen v. North Crowley", eventCoordinates: { lat: 32.92968306464252, lng: -97.11231812644931 }, studentLoc: { lat: 32.92968306464252, lng: -97.11371812644931 }, eventCategory: "Football", imageURL: "https://www.oneathletic.com/cdn/shop/files/OA-101.jpg", prevAttended: 6 },
        // { studentName: "Other Kaplan", studentId: "123456", event: "Allen v. North Crowley", eventCoordinates: { lat: 32.92968306464252, lng: -97.11231812644931 }, studentLoc: { }, eventCategory: "Football", imageURL: "https://i.pinimg.com/474x/2c/59/67/2c59674a6afc97d7d239f824cc577567.jpg", prevAttended: 0 },
    ]);
    const [chosenCheckIn, setChosenCheckIn] = React.useState(0);

    React.useEffect(() => {
        fetch(`${process.env.PUBLIC_URL}/admin/api/missingPoints`)
        .then(response => response.json())
        .then(data => {
            setRequests(data);
        })
    }, []);

    return (
        <div
            className={`w-full flex flex-col items-center justify-center gap-10 ${isBlurred ? "blur-sm" : "blur-none"}`}
            style={{ transition: "0.25s -webkit-filter linear" }}
        >
            <div className="text-4xl font-bold flex flex-row gap-0 max-md:flex-col max-md:gap-4">
                <span className='text-left flex-1 max-md:text-center'>
                    <b>Event: </b>{requests[chosenCheckIn].eventName}
                </span>
                <span className='text-center flex-1 font-bold'>
                    {requests[chosenCheckIn].studentName}
                    <br />
                    {requests[chosenCheckIn].studentID}
                </span>
                <span className='text-right flex-1 max-md:text-center'>
                    Prev. Attended <b>{requests[chosenCheckIn].prevAttended} {requests[chosenCheckIn].eventCategory}</b> Events
                </span>
            </div>
            <div className='flex flex-row w-full max-md:flex-col'>
                <div className='p-4 flex-1 flex items-center justify-center text-center'>
                    <LazyLoadImage
                        id='checkInImage'
                        alt={requests[chosenCheckIn].studentName + "'s Check-In"}
                        src={requests[chosenCheckIn].studentImagePath ? `${process.env.PUBLIC_URL}/pictures/missingPoints/${requests[chosenCheckIn].studentImagePath}` : PlaceholderImage}
                        height={400}
                        className='min-w-[225px] bg-gray-100 rounded-xl shadow-xl h-[400px]'
                    />
                </div>
                <div className='p-4 flex-1 [&>*]:w-full [&>*]:h-[400px] [&>*:first-child]:z-40 relative'>
                    <MapContainer center={{lat: 33.1097, lng: -96.6608}} zoom={13} scrollWheelZoom={true}>
                        <MapRefComponent />
                        <TileLayer
                            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        />
                        <Circle center={{ lat: requests[chosenCheckIn].eventLatitude, lng: requests[chosenCheckIn].eventLongitude }} radius={requests[chosenCheckIn].eventRadius}>
                            <Marker
                                position={{ lat: requests[chosenCheckIn].eventLatitude, lng: requests[chosenCheckIn].eventLongitude }}
                                icon={new L.DivIcon({
                                    html: ReactDOMServer.renderToString(<FontAwesomeIcon icon={faLocationDot} size='2xl' />),
                                    iconSize: [18, 24],
                                    className: 'text-orange-600'
                                })}
                            >
                                <Popup>
                                    {requests[chosenCheckIn].eventName}
                                </Popup>
                            </Marker>
                        </Circle>
                        { requests[chosenCheckIn].studentLatitude && requests[chosenCheckIn].studentLongitude ?
                            <Marker
                                position={{lat: requests[chosenCheckIn].studentLatitude, lng: requests[chosenCheckIn].studentLongitude}}
                                icon={new L.DivIcon({
                                        html: ReactDOMServer.renderToString(<FontAwesomeIcon icon={faLocationDot} size='2xl' />),
                                        iconSize: [18, 24],
                                        className: 'text-blue-600'
                                    })}
                            >
                                <Popup>
                                    {requests[chosenCheckIn].studentName}
                                </Popup>
                            </Marker>
                        : null }
                    </MapContainer>
                    { !requests[chosenCheckIn].studentLatitude || !requests[chosenCheckIn].studentLongitude ?
                        <div className='absolute right-6 top-4 text-right z-50'>
                            <span className='text-xl font-bold text-red-600'>
                                No Student Location Data
                            </span>
                        </div>
                     : null }
                </div>
            </div>
            <div className='flex flex-row items-center justify-center gap-10 max-md:mb-10'>
                <button
                    className='text-4xl font-bold text-green-600'
                    onClick={() => {
                        setIsBlurred(true);
                        setTimeout(() => {
                            if (chosenCheckIn > 0) {
                                setChosenCheckIn(chosenCheckIn - 1);
                            }
                            setIsBlurred(false);
                        }, 300);
                    }}
                >
                    <FontAwesomeIcon icon={faCheck} size='sm' />
                </button>
                <button
                    className='text-4xl font-bold text-red-600'
                    onClick={() => {
                        setIsBlurred(true);
                        setTimeout(() => {
                            if (chosenCheckIn < requests.length - 1) {
                                setChosenCheckIn(chosenCheckIn + 1);
                            }
                            setIsBlurred(false);
                        }, 300);
                    }}
                >
                    <FontAwesomeIcon icon={faX} size='sm' />
                </button>
            </div>
        </div>
    )
}

export default MissingPointsCarousel;