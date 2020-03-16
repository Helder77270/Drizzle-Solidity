import React from "react";
import PropTypes from "prop-types";

import { CardView } from "./Card.view";

export const Card = ({ shipCode }) => {
  return <CardView shipCode={shipCode} />;
};

Card.propTypes = {
  shipCode: PropTypes.string.isRequired
};

Card.defaultProps = {};
