import * as React from "react";

import { Button, TextField } from "@mui/material";
import { ToastContainer, toast } from 'react-toastify';

import TeacherNav from "../../components/TeacherNav";
import MapSelector from "../../components/MapSelector";
import LoadingOverlay from "../../components/LoadingOverlay";

function NewEditClubPage(props) {
  const [title, setTitle] = React.useState("New Club");

    const [clubInfo, setClubInfo] = React.useState({
	name: "", description: "", clugLogo: "", clubThumbnail: "",
	meetingTimes: "", locationName: "", websiteLink: "",
	instagramLink: "", twitterLink: "", youtubeLink: "",
	latitude: -1, longitude: -1, radius: -1
  });

  const [requests, setRequests] = React.useState(0);
    
  React.useEffect(() => {
    const clubID = parseInt(window.location.pathname.split("/").pop());
    if (!isNaN(clubID)) {
      setTitle("Edit Club - ...");

      const getClub = async () => {
        const res = await fetch(`${process.env.PUBLIC_URL}/faculty/api/club/${locationID}`, { headers: { Accept: "application/json" }, method: "POST" });
        return await res.json();
      }

      setRequests((prev) => prev + 1);
	getClub().then((club) => {
	    setRequests((prev) => prev - 1);
        document.title = "Edit Club - " + club.name;
        setTitle("Edit Club - " + club.name);
        setClubInfo(club);
      }).catch((err) => {
	  setRequests((prev) => prev - 1);
          // console.error(err);
      });

      return;
    }

      if (!window.location.pathname.endsWith("/clubs/new")) throw new Error("Invalid club ID.");
  }, []);

    const saveButtonClicked = async () => {
	var isNew = true;
    var urlPath = "/faculty/api/clubs/new"
	if (!window.location.pathname.endsWith("/clubs/new")) {
	    isNew = false;
      const clubID = parseInt(window.location.pathname.split("/").pop());
      urlPath = `/faculty/api/club/${clubID}/edit`
    }

	const filteredInfo = Object.assign({}, clubInfo);
	delete clubInfo.id;
	filteredInfo.latitude = parseFloat(filteredInfo.latitude);
	filteredInfo.longitude = parseFloat(filteredInfo.longitude);
	filteredInfo.radius = parseInt(filteredInfo.radius);
	  
	const keys = ["name", "description"];
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if (filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1) {
        toast.error(`${key} cannot be empty!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
        return;
      }
    }

	if (filteredInfo.locationName !== "" && filteredInfo.locationName !== null) {
	    const keys = ["latitude", "longitude", "radius"];
	    for (let i = 0; i < keys.length; i++) {
		const key = keys[i];
		if (filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1) {
		    toast.error(`${key} cannot be empty if locationName is set!`, {
			position: "top-right",
			autoClose: 2000,
			closeOnClick: true,
			pauseOnHover: true,
			theme: "light"
		    });
		    return;
		}
	    }
	}
	    
	if (requests > 0) {
	    toast.error(`Request already made. Please wait!`, {
		position: "top-right",
		autoClose: 2000,
		closeOnClick: true,
		pauseOnHover: true,
		theme: "light"
            });
	    return;
	}
	
	setRequests((prev) => prev + 1);
    try {
      const res = await fetch(`${process.env.PUBLIC_URL}${urlPath}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: JSON.stringify(filteredInfo)
      });

      setRequests((prev) => prev - 1);

      if (res.status === 200) {
          toast.success(`${isNew ? "Created" : "Updated"} club!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      } else {
	  const json = await res.json();
	  var errorText = res.statusText || json.reason;
	  if (errorText.includes("Duplicate")) errorText = "Name already exists!";
	  
          toast.error(errorText, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      }
    } catch (e) {
      console.error(e);
      setRequests((prev) => prev - 1);
    }
    }

    const updateMapValues = (latlng, radius) => {
	setClubInfo({
	    ...clubInfo,
	    latitude: latlng.lat,
	    longitude: latlng.lng,
	    radius: radius
	});
    }

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
	<TeacherNav selected="clubs" />
      <div className="flex flex-col items-stretch w-full">
	  <LoadingOverlay
          isActive={requests !== 0}
          text='Loading...'
        />

          <div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
          <span className="my-auto">
            {title}
          </span>
        </div>
        {/* Start a form, split it into two columns */}
          <form className="flex flex-row justify-between items-stretch p-10 gap-10 max-md:flex-col max-md:gap-4 max-md:p-4" onSubmit={(e) => {e.preventDefault();}}>
	  <ToastContainer
              position="top-right"
              autoClose={2000}
              hideProgressBar={false}
              newestOnTop
              closeOnClick
              pauseOnFocusLoss
              pauseOnHover
              theme="light"
	  />

          {/* Left column */}
          <div className="flex-1">
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="name">
              Club Name
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
		placeholder="Club Name"
		name="name"
		value={clubInfo?.name}
		onChange={(e) => {
                setClubInfo({
                  ...clubInfo,
                  name: e.currentTarget.value
                })
              }}
            />

            <div className="relative">
              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="description">
                Description
              </label>
              <TextField
                className="border bg-gray-100 rounded-xl w-full"
                placeholder="Description"
                name="description"
                  maxLength={255}
		  value={clubInfo?.description}
		  onChange={(e) => {
                      setClubInfo({
			  ...clubInfo,
			  description: e.currentTarget.value
                      })
		  }}
              />
            </div>
          </div>
	    
              {/* Right column */}
              <div className="flex-1 flex flex-col">

		  <div className="flex flex-row">
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			      Meeting Times
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="Meeting Times"
			      name="times"
			      value={clubInfo?.meetingTimes}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      meetingTimes: e.currentTarget.value
				  })
			      }}
			  />
		      </div>
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			      Meeting Location Name
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="STEAM B200"
			      name="times"
			      value={clubInfo?.locationName}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      locationName: e.currentTarget.value
				  })
			      }}
			  />			  
		      </div>
		  </div>
		  
		  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="map">
		      Choose Location
		  </label>
		  <MapSelector
		      lat={locationInfo?.latitude}
		      lng={locationInfo?.longitude}
		      radius={locationInfo?.radius}
		      onChange={updateMapValues}
		  />
		  
		  <div className="flex flex-row">
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			      Website Link
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="https://website.com"
			      name="times"
			      value={clubInfo?.websiteLink}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      websiteLink: e.currentTarget.value
				  })
			      }}
			  />
		      </div>
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			      Instagram Link
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="https://instagram.com/Club"
			      name="times"
			      value={clubInfo?.instagramLink}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      instagramLink: e.currentTarget.value
				  })
			      }}
			  />			  
		      </div>
		  </div>
		  
		  <div className="flex flex-row">
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			      Twitter Link
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="https://twitter.com/AClubName"
			      name="times"
			      value={clubInfo?.twitterLink}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      twitterLink: e.currentTarget.value
				  })
			      }}
			  />
		      </div>
		      <div className="flex-1">
			  <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="times">
			     Youtube Link
			  </label>
			  <TextField
			      className="border bg-gray-100 rounded-xl w-full"
			      placeholder="https://youtube.com/@clubname"
			      name="times"
			      value={clubInfo?.youtubeLink}
			      onChange={(e) => {
				  setClubInfo({
				      ...clubInfo,
				      youtubeLink: e.currentTarget.value
				  })
			      }}
			  />			  
		      </div>
		  </div>

            <div
              className="flex-1 flex flex-row-reverse items-end gap-4 mt-4 w-full mt-20"
            >
		<br />
		
              {/* Submit button */}
              <Button
                variant="contained"
                  color="success"
		  onClick={() => { saveButtonClicked(); }}
              >
                Save
              </Button>

              {/* Cancel button */}
              <Button
                variant="contained"
                color="error"
                component="a"
                href={process.env.PUBLIC_URL + "/dashboard"}
              >
                Cancel
              </Button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}

export default NewEditClubPage;
