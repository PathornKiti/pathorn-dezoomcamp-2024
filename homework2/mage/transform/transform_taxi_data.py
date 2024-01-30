if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    #Remove rows where the passenger count is equal to 0 or the trip distance is equal to zero.
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    # Create a new column lpep_pickup_date
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    # Rename columns from Camel Case to Snake Case
    data.columns = (data.columns
                    .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                    .str.lower()
                    )


    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
    assert output['vendor_id'].isin([1, 2]).all(), "Assertion Error: Invalid vendor_id value"
    assert (output['passenger_count'] > 0).all(), "Assertion Error: passenger_count should be greater than 0"
    assert (output['trip_distance'] > 0).all(), "Assertion Error: trip_distance should be greater than 0"
