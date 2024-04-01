import * as React from "react";
import dayjs from "dayjs";

import { DateTimePicker, TimePicker } from "@mui/x-date-pickers";
import { ToastContainer, toast } from 'react-toastify';

import AdminNav from "../../components/AdminNav";
import LoadingOverlay from "../../components/LoadingOverlay";
import { Autocomplete, Button, MenuItem, Select, TextField } from "@mui/material";

function NewEditRewardPage(props) {
  const [title, setTitle] = React.useState("New Reward");

  const [rewardInfo, setRewardInfo] = React.useState({});

  const [requests, setRequests] = React.useState(0);

  React.useEffect(() => {
    const rewardID = parseInt(window.location.pathname.split("/").pop());
    if (!isNaN(rewardID)) {
      setTitle("Edit Reward - ...");

      const getReward = async () => {
        const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/reward/${rewardID}`, { headers: { Accept: "application/json" }, method: "POST" });
        return await res.json();
      }

      setRequests((prev) => prev + 1);
      getReward().then((reward) => {
        document.title = "Edit Reward - " + reward.name;
        setTitle("Edit Reward - " + reward.name);
        setRewardInfo(reward);
        setRequests((prev) => prev - 1);
      }).catch((err) => {
        setRequests((prev) => prev - 1);
        // console.error(err);
      });

      return;
    }

    if (!window.location.pathname.endsWith("/admin/rewards/new")) throw new Error("Invalid reward ID.");
    setRewardInfo({
      name: "",
      description: "",
      cost: -1,
      gradesAllowed: -1
    });
  }, []);

    const grades = {
	"Fresh": 0b0001,
	"Soph": 0b0010,
	"Jun": 0b0100,
	"Sen": 0b1000
    }

  const saveButtonClicked = async () => {
    var isNew = true;
    var urlPath = "/admin/api/rewards/new"
    if (!window.location.pathname.endsWith("/admin/rewards/new")) {
      isNew = false;
      const rewardID = parseInt(window.location.pathname.split("/").pop());
      urlPath = `/admin/api/reward/${rewardID}/edit`
    }

    const filteredInfo = Object.assign({}, rewardInfo);

    const keys = Object.keys(filteredInfo);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if ((filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1)) {
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
        toast.success(`${isNew ? "Created" : "Updated"} reward!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      } else {
        toast.error(res.statusText, {
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

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
      <AdminNav selected="rewards" />
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
        <form className="flex flex-row relative justify-between items-stretch p-10 gap-10 max-md:flex-col max-md:gap-4 max-md:p-4">
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
              Reward Name
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Reward Name"
              name="name"
              value={rewardInfo?.name}
              onChange={(e) => {
                setRewardInfo({
                  ...rewardInfo,
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
                value={rewardInfo?.description}
                multiline={true}
                onChange={(e) => {
                  setRewardInfo({
                    ...rewardInfo,
                    description: e.currentTarget.value
                  })
                  // TODO: add #/255
                }}
              />
            </div>

	      <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="allowedGrades">
		  Allowed Grades
	      </label>
	      <Select
              className="border bg-gray-100 rounded-xl w-full"
              name="allowedGrades"
//		  value={}
		  onChange={(e) => {
		      const bitVal = e.currentTarget.value.reduce((a, c) => parseInt(a) + parseInt(c));
                setRewardInfo({
                  ...rewardInfo,
                  allowedGrades: bitVal
                })
		  }}
		  multiple
              >
		  {
		      Object.keys(grades).map((grade) => {
			  <MenuItem value={grades[grade]}>
			      {grade}
			  </MenuItem>
		      })
		  }
            </Select>

            <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="points">
              Point Cost
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Point Cost"
              type="number"
              name="points"
              value={rewardInfo.cost === -1 ? "" : rewardInfo.cost}
		onChange={(e) => {
                setRewardInfo({
                  ...rewardInfo,
                  cost: parseInt(e.currentTarget.value)
                })
              }}
            />
          </div>

          {/* Right column */}
          <div className="flex-1">
            {/* allowed grades */}
            <br />

            <div
              className="flex flex-row-reverse items-end gap-4 mt-4 w-full mt-20"
            >
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
                href={process.env.PUBLIC_URL + "/admin/events"}
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

export default NewEditRewardPage;
