import React from "react";
import PropTypes from "prop-types";

import { ShipView } from "./Ship.view";

export const Ship = ({ shipCode }) => {
  return <ShipView shipCode={shipCode} />;
};

Ship.propTypes = {
  shipCode: PropTypes.string.isRequired
};

Ship.defaultProps = {};
