import React from 'react';
import ReactDOM from 'react-dom/client';
import { CookiesProvider } from 'react-cookie';

import { LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs'

import './index.css';

import HomePage from "./pages/Home.js"
import ErrorPage from "./pages/error.js"
import SignInPage from "./pages/SignIn.js"
import SignUpPage from "./pages/SignUp.js"
import VerifyPage from './pages/Verify.js'

// Teacher Pages
import ClubsDashboard from './pages/teacher/ClubsDashboard.js';
import ClubPage from './pages/teacher/Club.js';
import NewEditClubPage from './pages/teacher/NewEditClub.js';
import EventRequestPage from './pages/teacher/EventRequest.js';

// Admin Pages
import CheckInRequestsPage from './pages/admin/CheckInRequests.js';
import UsersPage from './pages/admin/Users.js';

import EventRequestsPage from './pages/admin/EventRequests.js';
import EventsPage from './pages/admin/Events.js';
import NewEditEventPage from './pages/admin/NewEditEvent.js';
import EventCheckInPage from './pages/admin/EventCheckIn.js';

import LocationsPage from './pages/admin/Locations.js';
import NewEditLocationPage from './pages/admin/NewEditLocation.js';

import RewardsPage from './pages/admin/Rewards.js';
import NewEditRewardPage from './pages/admin/NewEditReward.js';

import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import MissingPointsRequestsPage from './pages/admin/MissingPointsRequests.js';

const router = createBrowserRouter([
  {
    path: "/",
    element: <HomePage />,
    errorElement: <ErrorPage />
  },
  {
    path: "/login",
    element: <SignInPage />,
  },
  {
    path: "/signup",
    element: <SignUpPage />,
  },
  {
    path: "/verify",
    element: <VerifyPage />,
  },
  {
    path: "/dashboard",
    element: <ClubsDashboard />,
  },
  {
    path: "/club/*",
    element: <ClubPage />,
  },
  {
    path: "/clubs/new",
    element: <NewEditClubPage />,
  },
  {
    path: "/club/edit/*",
    element: <NewEditClubPage />,
  },
  {
    path: "/event-request",
    element: <EventRequestPage />,
  },
  {
    path: "/admin/users",
    element: <UsersPage />,
  },
  {
    path: "/admin/event-requests",
    element: <EventRequestsPage />,
  },
  {
    path: "/admin/events",
    element: <EventsPage />,
  },
  {
    path: "/admin/events/new",
    element: <NewEditEventPage />,
  },
  {
    path: "/admin/events/edit/*",
    element: <NewEditEventPage />,
  },
  {
    path: "/admin/events/checkin/*",
    element: <EventCheckInPage />,
  },
  {
    path: "/admin/locations",
    element: <LocationsPage />,
  },
  {
    path: "/admin/locations/new",
    element: <NewEditLocationPage />,
  },
    
  {
    path: "/admin/locations/edit/*",
    element: <NewEditLocationPage />,
  },
  {
    path: "/admin/rewards",
    element: <RewardsPage />,
  },
  {
    path: "/admin/rewards/new",
    element: <NewEditRewardPage />,
  },
    
  {
    path: "/admin/rewards/edit/*",
    element: <NewEditRewardPage />,
  },
  {
    path: "/admin/review-checkins",
    element: <CheckInRequestsPage />,
  },
  {
    path: "/admin/review-missing-points",
    element: <MissingPointsRequestsPage />,
  }
],
  {
    basename: process.env.PUBLIC_URL ? `${process.env.PUBLIC_URL}/` : "/",
  });

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <LocalizationProvider dateAdapter={AdapterDayjs}>
    <CookiesProvider>
      <React.StrictMode>
        <RouterProvider router={router} />
      </React.StrictMode>
    </CookiesProvider>
  </LocalizationProvider>
);
