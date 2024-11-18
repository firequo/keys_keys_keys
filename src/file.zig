const std = @import("std");

const File = @This();

path_incl_name: std.ArrayList(u8),
name: std.ArrayList(u8),
checked: bool,
pub fn init(dir_path: []const u8, name: []const u8, allocator: std.mem.Allocator) !*File {
    const file = try allocator.create(File);
    file.path_incl_name = std.ArrayList(u8).init(allocator);
    file.name = std.ArrayList(u8).init(allocator);
    try file.path_incl_name.appendSlice(dir_path);
    try file.path_incl_name.appendSlice(name);
    try file.name.appendSlice(name);
    file.checked = false;
    return file;
}
