import React from "react";

import { AppBar, AppBarSection, AppBarSpacer } from "@progress/kendo-react-layout";
import { SvgIcon } from "@progress/kendo-react-common";
import { facebookIcon, linkedinIcon, twitterIcon } from "@progress/kendo-svg-icons";

import "./footer.styles.css";

export const Footer = () => {
  return (
    <AppBar position={"bottom"} className="appFooter" style={{ marginTop: "auto" }}>
      <AppBarSpacer style={{ width: 150 }} />
      <AppBarSection>
        <span title="No Title">© Copyright 2024</span>
      </AppBarSection>
      <AppBarSection>
        <span className="k-appbar-separator" />
      </AppBarSection>
      <AppBarSection> Follow Social:</AppBarSection>
      <AppBarSection className="social-section">
        <a className="k-button k-button-md k-rounded-md k-button-flat k-button-flat-base" href="https://www.facebook.com/" target="_blank" rel="noreferrer">
          <SvgIcon icon={facebookIcon} />
        </a>
        <a className="k-button k-button-md k-rounded-md k-button-flat k-button-flat-base" href="https://twitter.com/" target="_blank" rel="noreferrer">
          <SvgIcon icon={twitterIcon} />
        </a>
        <a className="k-button k-button-md k-rounded-md k-button-flat k-button-flat-base" href="https://www.linkedin.com/" target="_blank" rel="noreferrer">
          <SvgIcon icon={linkedinIcon} />
        </a>
      </AppBarSection>
    </AppBar>
  );
};
