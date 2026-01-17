module.exports = {
  typescript: true,
  icon: true,
  replaceAttrValues: {
    '#000': 'currentColor',
  },
  svgProps: {
    width: '{props.width || 24}',
    height: '{props.height || 24}',
    className: '{props.className}',
  },
};
