use super::Event;

#[derive(Debug, PartialEq)]
pub enum Metric {
    Counter {
        name: String,
        val: usize,
        sampling: Option<f32>,
    },
    Timer {
        name: String,
        val: usize,
        sampling: Option<f32>,
    },
    Gauge {
        name: String,
        val: usize,
        direction: Option<Direction>,
    },
    Set {
        name: String,
        val: String,
    },
}

#[derive(Debug, PartialEq)]
pub enum Direction {
    Plus,
    Minus,
}

impl From<Metric> for Event {
    fn from(metric: Metric) -> Event {
        match metric {
            Metric::Counter { name, val, .. } | Metric::Gauge { name, val, .. } => {
                let mut event = Event::new_empty_log();
                event
                    .as_mut_log()
                    .insert_explicit(name.into(), val.to_string().into());
                event
            }
            _ => Event::from(format!("{:?}", metric)),
        }
    }
}
