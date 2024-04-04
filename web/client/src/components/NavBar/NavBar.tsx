import React, { useContext, useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";

import { AppBar, AppBarSection, AppBarSpacer } from "@progress/kendo-react-layout";

import { ReactComponent as ProjectLogo } from "../../assets/images/logo.svg";
import { UserContext } from "../../context/UserContext";

import "./navbar.styles.css";
import { LoggedInUser } from "../User/LoggedInUser";

const pages = [{ label: "Home", redirectTo: "/" }];

export const NavBar = () => {
  const navigate = useNavigate();
  const userContext = useContext(UserContext);
  const location = useLocation();

  const [activePage, setActivePage] = useState("/");

  const currentPath = location.pathname;

  //local storage for external sites
  useEffect(() => {
    setActivePage(currentPath);
  }, [userContext]);

  const handleMenuItemClick = (path: any) => {
    setActivePage(path);
    navigate(path);
  };

  return (
    <AppBar positionMode="sticky" className="appHeader">
      <AppBarSpacer style={{ width: 32 }} />
      <ProjectLogo height="42" />
      <AppBarSpacer style={{ width: 32 }} />
      <AppBarSection>
        <span
          style={{
            cursor: "pointer",
            fontSize: 16,
          }}
          className="title"
          onClick={() => handleMenuItemClick("/")}>
          CI-CD DEMO
        </span>
      </AppBarSection>
      <AppBarSection>
        <ul className="navMenu">
          {pages.map((page) => (
            <li
              key={page.label}
              className={`navMenuItem ${activePage === page.redirectTo ? "active" : ""}`}
              onClick={() => {
                handleMenuItemClick(page.redirectTo);
              }}>
              <span>{page.label}</span>
            </li>
          ))}
        </ul>
      </AppBarSection>
      <AppBarSpacer />
      <AppBarSection>
        <ul className="navMenu">
          <li
            className={`navMenuItem ${activePage === "/about" ? "active" : ""}`}
            key="about"
            onClick={() => {
              handleMenuItemClick("/about");
            }}>
            <span>About</span>
          </li>
        </ul>
      </AppBarSection>
      <AppBarSection>
        <span className="k-appbar-separator" />
      </AppBarSection>
      <AppBarSection></AppBarSection>
      <AppBarSection>
        Welcome&nbsp;
        <LoggedInUser />
      </AppBarSection>
      <AppBarSpacer style={{ width: 10 }} />
    </AppBar>
  );
};
