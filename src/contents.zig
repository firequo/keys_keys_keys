const std = @import("std");
const Dir = @import("dir.zig");
const File = @import("file.zig");

const Contents = @This();

dirs: std.ArrayList(*Dir),
files: std.ArrayList(*File),
pub fn init(contents: *Contents, allocator: std.mem.Allocator) void {
    contents.dirs = std.ArrayList(*Dir).init(allocator);
    contents.files = std.ArrayList(*File).init(allocator);
}
