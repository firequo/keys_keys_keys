//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const builtin = @import("builtin");
const File = @import("file.zig");
const Dir = @import("dir.zig");
const Contents = @import("contents.zig");
const os = builtin.target.os.tag;

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    var args = try std.process.argsWithAllocator(gpa);
    defer args.deinit();
    const more_than_one_arg = args.skip();
    if (!more_than_one_arg) {
        return error.NoArgs;
    }
    const path = args.next().?;
    if (args.next()) |_| {
        return error.TooManyArgs;
    }

    //    var possible_matches = std.ArrayList(File).init();
    std.debug.print("{}\n", .{os});
    const home_dir: ?*Dir = switch (os) {
        .linux => Dir.init(path, "", gpa),
        .windows => null,
        else => null,
    };
    if (home_dir) |hd| {
        hd.list_all_contained_filenames();
    }
}
