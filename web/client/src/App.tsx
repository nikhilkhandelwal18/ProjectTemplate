import React from "react";
import { Route, Routes } from "react-router-dom";

import AppRoutes from "./app/routes";
import NavBar from "./components/NavBar";
import Footer from "./components/Footer";

import "./App.css";

const App = () => {
  return (
    <div className="app">
      <header className="header">
        <NavBar></NavBar>
      </header>
      <div className="content">
        <Routes>
          {AppRoutes.map((route: any, index: any) => {
            const { element, ...rest } = route;
            return <Route key={index} {...rest} element={element} />;
          })}
        </Routes>
      </div>
      <footer className="footer">
        <Footer></Footer>
      </footer>
    </div>
  );
};

export default App;
