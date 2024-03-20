import * as React from "react";
import dayjs from "dayjs";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEdit, faIdCard, faPlus, faSearch, faTrash } from '@fortawesome/free-solid-svg-icons'

import AdminNav from "../../components/AdminNav";
import LoadingOverlay from "../../components/LoadingOverlay";
import { Checkbox, FormControlLabel } from "@mui/material";

function RewardsPage(props) {
  const searchRef  = React.useRef(null);

  const [requests, setRequests] = React.useState(0);

  const [filter, setFilter] = React.useState("");

  const [rewards, setRewards] = React.useState(null);

  React.useEffect(() => {
    const getRewards = async () => {
      setRequests((prev) => prev + 1);

      const args = {};
      if (filter !== "") args.filterByName = filter;

	const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/rewards`, { headers: {
	    Accept: "application/json",
	    "Content-Type": "application/json"
	}, method: "POST", body: JSON.stringify(args) });

      return await res.json();
    }

    getRewards().then((rewards) => {
      setRewards(rewards);
      setRequests((prev) => prev - 1);
    }).catch((err) => {
      setRequests((prev) => prev - 1);
      console.error(err);
    });
  }, [setRewards, filter, setRequests])

  return (
    <div className="flex flex-row items-stretch min-h-[100vh] z-[100]">
      <AdminNav selected="rewards" />
      <div className="flex flex-col items-stretch w-full relative">
        <LoadingOverlay
          isActive={requests !== 0}
          text='Loading your content...'
        />
        <div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
          <span className="my-auto">
            Rewards
          </span>
        </div>
        <div
          className="flex flex-row justify-between items-stretch max-md:flex-col px-16 pt-8 max-md:p-4"
        >
          <div
            id="searchBox"
            className="flex flex-row justify-start items-stretch gap-4 w-1/2 [&>*]:self-stretch max-md:w-full max-md:flex-col max-md:gap-2"
          >
            <input
              onKeyDown={(e) => {
                if (e.key === "Enter") setFilter(e.currentTarget.value)
              }}
              ref={searchRef}
              type="text"
              className="border bg-gray-100 border-slate-600 rounded-xl p-2 w-full"
              placeholder="Search"
            />
            <button
              onClick={(e) => setFilter(searchRef.current.value)}
              className="bg-blue-950 text-white px-4 py-2 rounded-xl"
            >
              <FontAwesomeIcon icon={faSearch} size="xl" />
            </button>
          </div>
          <div className="max-md:mt-6 max-md:w-full">
            <button
              className="bg-blue-950 text-white px-4 py-2 rounded-xl font-semibold max-md:w-full"
            >
              <a
                href={process.env.PUBLIC_URL + "/admin/rewards/new"}
              >
                <FontAwesomeIcon icon={faPlus} size="lg" className="mr-2" />
                Create Reward
              </a>
            </button>
          </div>
        </div>
        <div
          className="pt-8 px-16 w-full max-md:pt-4 max-md:px-4">
          <table
            className="w-full bg-blue-900 text-white table-fixed text-center border border-slate-400 [&_th]:border-slate-400 [&_td]:border-slate-400 [&_th]:border-r [&_td]:border-r [&_th]:p-2 [&_td]:p-2"
          >
            <thead className="border-b border-slate-400">
              <tr className="text-xl font-bold">
                <th>Name</th>
                <th>Cost</th>
                <th>Grades</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody className="border-b border-slate-400">
              {
                rewards?.map((reward, i) =>
                  <tr key={reward.id} className="text-l">
                    <td>{reward.name}</td>
                    <td>{reward.cost}</td>
                    <td>{reward.allowedGrades}</td>
                    <td className="[&>*]:mx-4">
                      <a className="bg-blue-950 text-white px-4 py-2 rounded-xl" href={process.env.PUBLIC_URL + `/admin/rewards/edit/${reward.id}`}>
                        <FontAwesomeIcon icon={faEdit} size="lg" />
                      </a>
                      <button className="bg-blue-950 text-white px-4 py-2 rounded-xl"><FontAwesomeIcon icon={faTrash} size="lg" /></button>
                    </td>
                  </tr>
                )
              }
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default RewardsPage;
