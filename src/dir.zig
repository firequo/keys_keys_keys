const std = @import("std");
const Contents = @import("contents.zig");
const File = @import("file.zig");

const Dir = @This();

path_incl_name: std.ArrayList(u8),
name: std.ArrayList(u8),
contents: ?*Contents = null,
pub fn init(dir_path: []const u8, name: []const u8, allocator: std.mem.Allocator) *Dir {
    const dir = allocator.create(Dir) catch unreachable;
    dir.path_incl_name = std.ArrayList(u8).init(allocator);
    dir.name = std.ArrayList(u8).init(allocator);
    dir.path_incl_name.appendSlice(dir_path) catch unreachable;
    dir.path_incl_name.appendSlice("/") catch unreachable;
    dir.path_incl_name.appendSlice(name) catch unreachable;
    dir.name.appendSlice(name) catch unreachable;
    // std.debug.print("{s}\n", .{dir.path_incl_name.items});
    if (get_contents(dir.path_incl_name.items, allocator)) |contents| {
        dir.contents = contents;
    } else |e| {
        std.debug.print("{}\n", .{e});
        dir.contents = null;
    }
    return dir;
}
pub fn get_contents(dir_path: []const u8, allocator: std.mem.Allocator) !?*Contents {
    var dir = try std.fs.openDirAbsolute(dir_path, .{ .iterate = true });
    defer dir.close();
    var contents = try allocator.create(Contents);
    contents.init(allocator);
    var iter = dir.iterate();
    var any_contents = false;
    while (try iter.next()) |f| {
        any_contents = true;
        switch (f.kind) {
            .file => {
                try contents.files.append(try File.init(dir_path, f.name, allocator));
                //               std.debug.print("{s}\n", .{contents.files.items[contents.files.items.len - 1].path_incl_name.items});
            },
            .directory => {
                // if (std.mem.eql(u8, f.name, ".ssh")) std.debug.print("\naaaaaaa\n", .{});
                try contents.dirs.append(Dir.init(dir_path, f.name, allocator));
            },
            else => {},
        }
    }
    if (any_contents) return contents;
    return null;
}
pub fn list_all_contained_filenames(dir: *Dir) void {
    if (dir.contents) |contents| {
        for (contents.files.items) |file| {
            const stdout = std.io.getStdOut().writer();
            stdout.print("{s}\n", .{file.name.items}) catch unreachable;
        }
        for (contents.dirs.items) |d| {
            d.list_all_contained_filenames();
        }
    }
}
