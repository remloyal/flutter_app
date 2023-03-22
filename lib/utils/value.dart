const defaultValueLine = '-';
const defaultValueOutdoor = '室外';
formatStr(value) {
  return formatStrWithDefault(value, null);
}

formatStrDefaultLine(value) {
  return formatStrWithDefault(value, defaultValueLine);
}

formatStrWithDefault(value, defaultValue) {
  if (value != null) {
    return value;
  }

  if (defaultValue == null || defaultValue == null) {
    return "";
  }

  return defaultValue;
}
