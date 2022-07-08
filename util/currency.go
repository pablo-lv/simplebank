package util

const (
	USD = "USD"
	EUR = "EUR"
	MXN = "MXN"
	CAD = "CAD"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, MXN, EUR:
		return true
	}
	return false
}
