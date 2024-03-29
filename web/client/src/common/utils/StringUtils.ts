export function stringFormat(str: string, ...values: string[]) {
    for (let index = 0; index < values.length; index++) {
      str = str.replace(`{${index}}`, values[index]);
    }
    return str;
  }
  