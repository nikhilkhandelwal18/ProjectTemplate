import React from "react";
import buildInfo from "../../buildinfo.json";

const containerStyle = {
  display: "grid",
  gridTemplateColumns: "1fr 1fr", // Three equal columns
  gap: "10px",
  justifyContent: "flex-start", // Left-align content
  maxWidth: "700px", // Set maximum width for the container
  margin: "auto",
  border: "1px solid #ccc",
  padding: "10px",
  borderRadius: "8px",
};

const tableContainerStyle: React.CSSProperties = {
  textAlign: "left",
  margin: "auto",
};

const labelStyle: React.CSSProperties = {
  fontWeight: "bold",
  textAlign: "right",
  paddingRight: "10px",
};

export const SystemInfo = () => {
  return (
    <div>
      <h1>Build Information</h1>
      <div style={tableContainerStyle}>
        <div style={containerStyle}>
          <div style={labelStyle}>Application Name</div>
          <div>App Name</div>

          <div style={labelStyle}>Pipeline</div>
          <div>{buildInfo.pipeline}</div>

          <div style={labelStyle}>Repository</div>
          <div>{buildInfo.repository}</div>

          <div style={labelStyle}>Branch</div>
          <div>{buildInfo.branch}</div>

          <div style={labelStyle}>Build Number</div>
          <div>{buildInfo.buildNumber}</div>
        </div>
      </div>
    </div>
  );
};
