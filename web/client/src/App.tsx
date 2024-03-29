import React, { useContext, useEffect, useState } from "react";
import { Route, Routes } from "react-router-dom";

import { Loader } from "@progress/kendo-react-indicators";

import AppRoutes from "./app/routes";
import NavBar from "./components/NavBar";
import Footer from "./components/Footer";
//import { isObjectNullOrEmpty } from "./common/utils/ObjectUtils";
import { UserContext } from "./context/UserContext";

// import "bootstrap/dist/css/bootstrap.min.css";

import "./App.css";

const App = () => {
  const userContext = useContext(UserContext);

  return (
    <div className="app">
      <header className="header">
        <NavBar></NavBar>
      </header>
      <div className="content">
        {!userContext.user ? (
          <Loader
            type={"infinite-spinner"}
            style={{
              width: "2rem",
              height: "2rem",
              position: "absolute",
              left: "50%",
              top: "50%",
            }}
          />
        ) : (
          <Routes>
            {AppRoutes.map((route: any, index: any) => {
              const { element, ...rest } = route;
              return <Route key={index} {...rest} element={element} />;
            })}
          </Routes>
        )}
      </div>
      <footer className="footer">
        <Footer></Footer>
      </footer>
    </div>
  );
};

export default App;
