#!/usr/bin/python

if __name__ == "__main__":

    from argparse import ArgumentParser
    import re

    parser = ArgumentParser()
    parser.add_argument("file", help="Audio filename to process", type=str)
    parser.add_argument("-of", "--out-format", help="The output file format of tracks", type=str, choices=["mp3"])
    parser.add_argument("-cs", "--chunks", nargs="+", help="Chunk of audio file to extract, with this format 'XX:XX:XX trackname'", type=str, required=True)

    args = parser.parse_args()

    parsed_chunks = args.chunks
    chunks = []
    for parsed_chunk in parsed_chunks:
        print(parsed_chunk)
        m = re.search("([0-9]{2}:[0-9]{2})\s(.*)", parsed_chunk)
        if m is not None:
            start = m.group(1)
            filename = m.group(2)

            m = re.search("([0-9]{2}):([0-9]{2})", start)
            if m is not None:
                minutes = m.group(1)
                seconds = m.group(2)

                milliseconds = 1000 * (int(minutes)*60 + int(seconds))

                chunk = (milliseconds, filename)
                chunks.append(chunk)

    from pydub import AudioSegment
    song = AudioSegment.from_file(args.file)

    chunks = sorted(chunks, key=lambda chunk: chunk[0], reverse=True)

    end = len(song)
    for i, chunk in enumerate(chunks):
        start = chunk[0]
        track = song[start:end]
        track.export("%d %s.mp3" % (i, chunk[1]), format="mp3")
        end = start
