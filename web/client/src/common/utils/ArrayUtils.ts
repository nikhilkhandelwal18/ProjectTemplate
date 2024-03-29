export function isArrayNullOrEmpty(obj?: any[] | null) {
  return !obj || obj.length === 0;
}
