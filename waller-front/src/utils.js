import moment from 'moment';

function removeNegativePart(num) {
  return num
    .toString()
    .split('-')
    .pop();
}

export function calcDiffDate({ dateNow, resultDate }) {
  const resultDateMoment = moment(resultDate);
  const dateNowMoment = moment(dateNow);

  const diffDays = resultDateMoment.diff(dateNowMoment, 'days');
  const diffHours =
    diffDays <= 1 ? resultDateMoment.diff(dateNowMoment, 'hours') : null;

  const diffMinutes =
    diffDays <= 1
      ? diffHours - (resultDateMoment.diff(dateNow, 'minutes') % 60)
      : null;

  const diffSeconds =
    diffDays <= 1
      ? diffMinutes - (resultDateMoment.diff(dateNow, 'seconds') % 60)
      : null;

  const diffDate =
    diffDays <= 1
      ? `${diffHours}:${
          removeNegativePart(diffMinutes) < 10
            ? '0' + removeNegativePart(diffMinutes)
            : removeNegativePart(diffMinutes)
        }:${diffSeconds < 10 ? '00' : removeNegativePart(diffSeconds)}`
      : diffDays;

  const diffDateUnity = diffDays <= 1 ? 'horas' : 'dias';

  return { diffDate, diffDateUnity };
}

export default {
  calcDiffDate
};
