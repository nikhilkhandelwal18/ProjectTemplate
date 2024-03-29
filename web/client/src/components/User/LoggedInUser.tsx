import { Loader } from "@progress/kendo-react-indicators";
import React, { useCallback, useContext, useState } from "react";
import { UserContext } from "../../context/UserContext";

export const LoggedInUser = () => {
  const userContext = useContext(UserContext);

  if (!userContext.user) {
    return <Loader size="small" type={"pulsing"} />;
  } else {
    return (
      <span className="title">
        Welcome &nbsp;
        <b>{userContext.user?.displayName}</b>
      </span>
    );
  }
};
