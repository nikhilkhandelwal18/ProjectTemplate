export function isObject(obj: any) {
  return !!obj && typeof obj === "object";
}

export function isObjectNullOrEmpty(obj?: Object) {
  return !obj || Object.keys(obj).length === 0;
}
