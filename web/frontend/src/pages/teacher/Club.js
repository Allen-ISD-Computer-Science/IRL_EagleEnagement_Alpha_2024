import * as React from "react";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit, faEye, faLink } from '@fortawesome/free-solid-svg-icons'
import { faInstagram, faXTwitter, faYoutube } from "@fortawesome/free-brands-svg-icons"

import TeacherNav from "../../components/TeacherNav";
import { Button } from "@mui/material";

function ClubPage(props) {
    const [requests, setRequests] = React.useState(0);

    const [showPast, setShowPast] = React.useState(false);
    const [filter, setFilter] = React.useState("");


    const [clubID, setClubID] = React.useState(-1);
    const [clubObj, setClubObj] = React.useState(null);

    React.useEffect(() => {
	const parsedClubID = parseInt(window.location.pathname.split("/").pop());
	setClubID(parsedClubID);
	if (isNaN(parsedClubID)) throw new Error("Invalid club ID.");

	
	const getClub = async () => {
	    setRequests((prev) => prev + 1);
	    
	    let url = `${process.env.PUBLIC_URL}/faculty/api/club/` + parsedClubID
	    console.log(url)

	    const res = await fetch(url, { headers: {
		Accept: "application/json"
	    }, method: "POST"});

	    return await res.json()

	    // const json = await res.json();
	    //if (!json.name) throw new Error("Invalid club?");
	    //return json;
	}

	getClub().then((club) => {
	    document.title = "Club - " + club.name;
	    setClubObj(club);
	}).catch((err) => {
	    // console.error(err);
	});
    }, []);

    return (
	<div className="flex flex-row items-stretch min-h-[100vh]">
	    <TeacherNav selected="clubs" />
	    <div className="flex flex-col items-stretch w-full">
		<div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
		    <span className="my-auto">
			Club - {clubObj?.name}
		    </span>
		</div>

		<div
		    className="p-12 flex flex-col items-stretch max-md:px-5"
		>
		    <div
			className="flex flex-row justify-between items-stretch gap-40 max-md:flex-col max-md:gap-4"
		    >
			<div className="flex flex-col">
			    <img
				srcSet={process.env.PUBLIC_URL + "/pictures/clubLogos/" + clubID}
				alt={clubObj?.name + " Logo"}
				className="aspect-square object-contain object-center w-[185px] mx-3 overflow-hidden shrink-0 max-w-full rounded-[50%] max-md:mt-10"
			    />
			    <span className="text-xl">{clubObj?.studentsFollowing + " Students Following"}</span>
			</div>
			<div className="flex flex-col leading-10 relative">    
			    <Button
				type="a"
				href={`${process.env.PUBLIC_URL}/club/edit/${clubID}`}
				className="!absolute top-0 right-0 !text-black"
			    >
				<FontAwesomeIcon icon={faEdit} size="2xl" />
			    </Button>

			    <span className="text-4xl font-bold my-6 max-md:text-2xl">{clubObj?.name}</span>
			    <span className="text-2xl min-h-[96px] pr-10 max-md:text-xl max-md:pr-4">{clubObj?.description}</span>
			    <div className="flex flex-row gap-5 text-xl max-md:text-l max-md:flex-col">
				{clubObj?.websiteLink ? <a href={clubObj?.websiteLink} target="_blank" rel="noreferrer"><FontAwesomeIcon icon={faLink} size="s" /> {clubObj?.link}</a> : ""}
				{clubObj?.twitter ? <a href={"https://x.com/" + clubObj?.twitter} target="_blank" rel="noreferrer"><FontAwesomeIcon icon={faXTwitter} size="s" /> @{clubObj?.twitter}</a> : ""}
				{clubObj?.instagram ? <a href={"https://instagram.com/" + clubObj?.instagram} target="_blank" rel="noreferrer"><FontAwesomeIcon icon={faInstagram} size="s" /> @{clubObj?.instagram}</a> : ""}
				{clubObj?.youtube ? <a href={"https://youtube.com/" + clubObj?.youtube} target="_blank" rel="noreferrer"><FontAwesomeIcon icon={faYoutube} size="s" /> {clubObj?.youtube}</a> : ""}
			    </div>
			</div>

		    </div>

		    <div className="flex flex-col mt-10">
			<h3 className="text-3xl font-bold text-center">Meeting Logs</h3>
			<table
			    className="bg-gray-100 mt-8 table-fixed text-center w-full border border-slate-600 [&_th]:border-slate-600 [&_td]:border-slate-600 [&_th]:border-r [&_td]:border-r [&_th]:p-2 [&_td]:p-2"
			    style={{ borderRadius: "1rem !important" }}
			>
			    <thead className="border-b border-slate-600">
				{/* date, number of students, and actions columns */}
				<tr className="text-xl font-bold">
				    <th>Date</th>
				    <th>Number of Students</th>
				    <th>Actions</th>
				</tr>
			    </thead>
			    <tbody className="border-b border-slate-600">
				{/* meeting logs */}
				{
				    clubObj?.meetingLogs?.map((meetingLog, i) =>
					<tr key={i} className="text-l">
					    <td>{meetingLog.date}</td>
					    <td>{meetingLog.numStudents}</td>
					    <td>
						<button className="bg-blue-950 text-white px-4 py-2 rounded-xl"><FontAwesomeIcon icon={faEye} size="lg" /></button>
					    </td>
					</tr>
				    )
				}
			    </tbody>
			</table>
		    </div>
		</div>
	    </div>
	</div>
    );
}

export default ClubPage;
