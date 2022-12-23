use nom::character::complete::digit1;
use nom::IResult;

#[allow(dead_code)]
fn parser(input: &str) -> IResult<&str, &str> {
    digit1(input)
}

#[cfg(test)]
mod tests {
    use super::*;
    use nom::Err;
    use nom::error::Error;
    use nom::error::ErrorKind;

    #[test]
    fn test_parser() {
        assert_eq!(parser("21c"), Ok(("c", "21")));
        assert_eq!(parser("c1"), Err(Err::Error(Error::new("c1", ErrorKind::Digit))));
        assert_eq!(parser(""), Err(Err::Error(Error::new("", ErrorKind::Digit))));
    }
}
