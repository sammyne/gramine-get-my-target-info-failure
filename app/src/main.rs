use std::fs;

fn main() -> Result<(), String> {
    pub const MY_TARGET_INFO_PATH: &'static str = "/dev/attestation/my_target_info";

    let v = fs::read(MY_TARGET_INFO_PATH).map_err(|err| format!("read: {}", err))?;

    print!("hex(my_target_info) = ");
    for vv in v {
        print!("{:02x}", vv);
    }
    println!();

    Ok(())
}
