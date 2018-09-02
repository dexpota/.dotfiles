#!/usr/bin/env python
"""
A simple dependency graph generator for C/C++. It creates a graph of all files included by the header file passed as argument.
"""
import os
import sys
import re
from graphviz import Digraph
from argparse import ArgumentParser
from subprocess import check_output
import subprocess
from random import random, randint


def is_subdirectory(root, directory):
    abs_directory = os.path.realpath(directory)
    abs_root = os.path.realpath(root)

    relative = os.path.relpath(abs_root, abs_directory)

    escaped_pardir = re.escape(os.pardir)
    escaped_sep = re.escape(os.sep)
    # everything which resemble a string such as one o these
    # '../../../../' '../' '..' '../..'
    # will pass the test
    return bool(
        re.match("({pardir}{sep})*({pardir}{sep}?\s?$)".format(pardir=escaped_pardir, sep=escaped_sep), relative))


def gcc_system_paths():
    try:
        with open(os.devnull, "r") as devnull:
            output = check_output(["cpp", "-xc++", "-v"], stdin=devnull, stderr=subprocess.STDOUT)

        match = re.search("#include <.*\n((.*\n)+)End", output, re.MULTILINE)
        return match.group(1).split()
    except:
        return []

system_paths = ["/usr/local/include",
                "/usr/target/include",
                "/usr/include"]
user_include_dirs = []

system_paths.extend(gcc_system_paths())


def extract_includes(filename):
    includes = []

    regex = re.compile('^\s*\#include\s*(["<][^">]+[">])')
    with open(filename, 'r') as fp:
        for line in fp:
            match = regex.match(line)
            if match:
                includes.append(match.group(1))  # include's argument
    return includes


def search_include(fp, include, paths=None):
    # TODO: check for duplicated paths
    for path in paths:
        fname = os.path.join(path, include)
        if os.path.isfile(fname):
            return fname
    return None


def build_tree(fp, system_dependencies=True):
    vertices = []
    processed_files = []
    build_tree_impl(fp, vertices, processed_files, system_dependencies)
    return dict(vertices)


def build_tree_impl(filename, vertices, processed=None, system_dependencies=True):
    if not processed:
        processed = []

    # check if current filename has been already processed
    if filename in processed:
        return

    processed.append(filename)

    files = []
    dependencies = []
    for include in extract_includes(filename):
        paths = []
        if include[0] == "<":
            include = include.strip('<>')
            if system_dependencies:
                paths = system_paths
            paths.extend(user_include_dirs)
        elif include[0] == '"':
            include = include.strip('"')
            paths = [os.path.dirname(filename)]
        else:
            assert False

        filepath = search_include(filename, include, paths)
        if not filepath:
            filepath = include

        dependencies.append(filepath)

    vertex = (filename, dependencies)
    vertices.append(vertex)

    for filename in dependencies:
        if os.path.isfile(filename) or os.path.islink(filename):
            build_tree_impl(filename, vertices, processed, system_dependencies)


def main():
    parser = ArgumentParser(description=
                            "Build a simple dependency graph for a C/C++ header file and output a DOT graph and its "
                            "renderer. Given a directory or a filename this program generate a dependency graph of "
                            "every header files and their dependencies.")
    # Process directory passed by command line.
    parser.add_argument("directory_or_file", nargs=1, type=str,
                        help="A directory or a filename to process. If it is a directory this script will process "
                             "every files inside of it.")
    # Proceed recursively, not used yet
    # parser.add_argument("-r", nargs="?", help="Process recursively every
    # header file inside the directory")

    # Additional include directories
    parser.add_argument("-i", nargs="*", type=str,
                        help="Additional directories where to look for system header file. By default "
                             "we look for header file in these directories: /usr/local/include, "
                             "/usr/target/include, /usr/include.")

    parser.add_argument("-a", action="store_true", default=False, help="Expand all dependencies.")
    parser.add_argument("-l", action="store_true", default=False, help="Generate the legend in a separate file.")
    parser.add_argument("-f", type=str, help="Output format, the default value is PNG.", default="png")

    ns = parser.parse_args()

    if ns.i:
        user_include_dirs.extend(ns.i)

    if os.path.isdir(ns.directory_or_file[0]):
        current_directory = ns.directory_or_file[0]

        directory = sys.argv[1]
        print directory
        # directory = "./"
        ignored = [".git", ".idea"]
        extensions = [".h", "hpp", "hxx"]
        files = []

        for dirpath, dirnames, filenames in os.walk(directory, topdown=True):
            # print "Current path: " + str(dirpath)
            # print "Directories inside this path: " + str(dirnames)
            # print "File: " + str(filenames)

            dirnames[:] = filter(lambda dire: dire not in ignored, dirnames)

            for filename in filenames:
                name, extension = os.path.splitext(filename)
                if extension in extensions:
                    files.append(os.path.abspath(os.path.join(dirpath, filename)))

                    # dirnames = filter(lambda dir: not dir in ignored,
                    # dirnames)

                    # if len(dirnames) > 0:
                    #    del dirnames[0]

    elif os.path.isfile(ns.directory_or_file[0]) or os.path.islink(ns.directory_or_file[0]):
        filename = ns.directory_or_file[0]

        graph = build_tree(filename, ns.a)
        dot = Digraph(comment='Dependency graph of {}'.format(filename), format=ns.f)
        dot.attr("graph", splines="true")

        r = lambda: randint(0, 255)

        not_visited = {}
        for node, edges in graph.iteritems():
            for edge in edges:
                if edge not in graph and edge not in not_visited:
                    # node is connected to edge but edge is not connected to
                    # any other nodes.
                    not_visited[edge] = {
                        "color": '#%02X%02X%02X' % (r(), r(), r())
                    }

        for node, edges in graph.iteritems():
            dot.node(node, os.path.basename(node), shape="circle")
            for edge in edges:
                if edge in not_visited:
                    new_node = str(random())
                    dot.node(new_node, label=edge, shape="hexagon", style="filled", fillcolor=not_visited[edge]["color"])
                    dot.edge(node, new_node)
                else:
                    dot.edge(node, edge)

        styles = {
            'graph': {
                'label': 'Dependency graph',
                'fontsize': '16',
                'fontcolor': 'white',
                'bgcolor': '#333333',
                'rankdir': 'TB',
            },
            'nodes': {
                'fontname': 'Helvetica',
                'shape': 'hexagon',
                'fontcolor': 'white',
                'color': 'white',
                'style': 'filled',
                'fillcolor': '#006699',
            },
            'edges': {
                'color': 'white',
                'arrowhead': 'open',
                'fontname': 'Courier',
                'fontsize': '12',
                'fontcolor': 'white',
            }
        }

        def apply_styles(graph, styles):
            graph.graph_attr.update(
                ('graph' in styles and styles['graph']) or {}
            )
            graph.node_attr.update(
                ('nodes' in styles and styles['nodes']) or {}
            )
            graph.edge_attr.update(
                ('edges' in styles and styles['edges']) or {}
            )
            return graph
        apply_styles(dot, styles)

        if ns.l:
            # Maybe is better to generate another image file and then merge the
            # two images, or use gvpack
            # gvpack -g legend1.gv dependencies1.gv | neato -n2 -Tpng > out.png
            legend = Digraph(name="legend", comment="Legend", format=ns.f)
            table = "<<table border='0' cellpadding='2' cellspacing='0' cellborder='0'>"
            for key, value in not_visited.iteritems():
                table += "<tr><td align='right'>{}</td>".format(key)
                table += "<td align='right' width='30' bgcolor='{0}'> </td></tr>".format(value["color"])
            table += "</table>>"
            legend.node("key", label=table, shape="plaintext", fillcolor="transparent")
            apply_styles(legend, styles)
            legend.render("legend.gv")

        dot.render('dependencies.gv')

if __name__ == "__main__":
    main()
