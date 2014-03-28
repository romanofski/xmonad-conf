#!/usr/bin/env python
import urllib
from lxml import html


APIURL = 'http://jp.translink.com.au/travel-information/network-information/stops-and-stations/stop/600029?RouteCode=&Direction=Upward'
LINES = ['BRIP', 'BRSP']


class Hit(object):

    def __init__(self, route, direction, scheduled, departs):
        self.route = route
        self._direction = direction
        self.scheduled = scheduled
        self.departs = departs

    @property
    def direction(self):
        clean = self._direction.split()[:-1]
        return ' '.join(clean)


def get_next_trains():
    page = html.parse(urllib.urlopen(APIURL))
    result = []
    for row in page.xpath("//div[@id='timetable']/table/tbody/tr"):
        route, direction, scheduled, departs, _ = (
            [x.text_content().strip() for x in row.xpath('td')]
        )
        if route not in LINES:
            continue
        else:
            result.append(Hit(route, direction, scheduled, departs))
    return result


if __name__ == '__main__':
    trains = get_next_trains()
    if not trains:
        print("No train data available.")
    else:
        data = ['{x.direction} - {x.departs}'.format(x=x) for x in trains[:2]]
        print ' / '.join(data)
