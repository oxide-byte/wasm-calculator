pub mod add_view;
pub mod sub_view;
pub mod min_view;
pub mod mul_view;
mod div_view;
mod max_view;
mod power_view;

pub use crate::modules::add_view::AddView;
pub use crate::modules::sub_view::SubView;
pub use crate::modules::min_view::MinView;
pub use crate::modules::mul_view::MulView;
pub use crate::modules::div_view::DivView;
pub use crate::modules::max_view::MaxView;
pub use crate::modules::power_view::PowerView;