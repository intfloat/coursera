package course.labs.locationlab;

import java.util.ArrayList;
import java.util.List;

import android.app.ListActivity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.Toast;

public class PlaceViewActivity extends ListActivity implements LocationListener {
	private static final long FIVE_MINS = 5 * 60 * 1000;

	private static String TAG = "Lab-Location";

	// The last valid location reading
	private Location mLastLocationReading;

	// The ListView's adapter
	private PlaceViewAdapter mAdapter;

	// default minimum time between new location readings
	private long mMinTime = 5000;

	// default minimum distance between old and new readings.
	private float mMinDistance = 1000.0f;

	// Reference to the LocationManager
	private LocationManager mLocationManager;

	// A fake location provider used for testing
	private MockLocationProvider mMockLocationProvider;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		// TODO - Set up the app's user interface
		// This class is a ListActivity, so it has its own ListView
		// ListView's adapter should be a PlaceViewAdapter
		super.onCreate(savedInstanceState);
		this.mLocationManager = (LocationManager) this.getApplicationContext().getSystemService(LOCATION_SERVICE);
		mAdapter = new PlaceViewAdapter(this.getApplicationContext());
		LayoutInflater inflator = this.getLayoutInflater();		
		
		// TODO - add a footerView to the ListView
		// You can use footer_view.xml to define the footer
		this.getListView().setFooterDividersEnabled(true);
		View footer = inflator.inflate(R.layout.footer_view, null);		
		
		footer.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				log("Entered footerView.OnClickListener.onClick()");
				if(null == mLastLocationReading){
					log("Location data is not available");
					return;
				}
				boolean seen = false;
//				check to see if we've already seen this place
				ArrayList<PlaceRecord> arr = mAdapter.getList();
				if(null != arr){
					for(int i=0; i<arr.size(); i++){
						if(arr.get(i).intersects(mLastLocationReading)){
							seen = true;
							break;
						}
					}// end for loop
				}// end if clause
//				already seen this place
				if(seen){
					log("You already have this location badge");
					Toast.makeText(getApplicationContext(), "You already have this location badge.",
							Toast.LENGTH_LONG).show();					
				}
				else{
					log("Starting Place Download");
//					execute the task
					PlaceDownloaderTask task = new PlaceDownloaderTask(PlaceViewActivity.this);
					task.execute(mLastLocationReading);
				}// end else if clause
				
				return;
			}// end method onClick
			
		});
		// When the footerView's onClick() method is called, it must issue the
		// follow log call
		// log("Entered footerView.OnClickListener.onClick()");
		
		// footerView must respond to user clicks.
		// Must handle 3 cases:
		// 1) The current location is new - download new Place Badge. Issue the
		// following log call:
		// log("Starting Place Download");

		// 2) The current location has been seen before - issue Toast message.
		// Issue the following log call:
		// log("You already have this location badge");
		
		// 3) There is no current location - response is up to you. The best
		// solution is to disable the footerView until you have a location.
		// Issue the following log call:
		// log("Location data is not available");
		this.getListView().addFooterView(footer);
		this.getListView().setAdapter(mAdapter);
		return;

	}

	@Override
	protected void onResume() {
		super.onResume();

		mMockLocationProvider = new MockLocationProvider(
				LocationManager.NETWORK_PROVIDER, this);

		// TODO - Check NETWORK_PROVIDER for an existing location reading.
		// Only keep this last reading if it is fresh - less than 5 minutes old.
//		if(this.mLocationManager == null)
//		log("DEBUG: on resume");
		List<String> providers = this.mLocationManager.getAllProviders();
		for(String provider : providers){
			Location location = this.mLocationManager.getLastKnownLocation(provider);
			if(null != location){
				if(age(location)<FIVE_MINS && 
					(this.mLastLocationReading==null || 
					location.getTime()>this.mLastLocationReading.getTime())){
					this.mLastLocationReading = location;
				}
			}
		}// end for loop
		// TODO - register to receive location updates from NETWORK_PROVIDER		
		this.mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 
				this.mMinTime, this.mMinDistance, this);
		
		return;
	}// end method onResume

	@Override
	protected void onPause() {

		mMockLocationProvider.shutdown();

		// TODO - unregister for location updates
		this.mLocationManager.removeUpdates(this);
		super.onPause();
	}

	public void addNewPlace(PlaceRecord place) {

		log("Entered addNewPlace()");
		mAdapter.add(place);

	}

	@Override
	public void onLocationChanged(Location currentLocation) {

		// TODO - Handle location updates
		// Cases to consider
		// 1) If there is no last location, keep the current location.
		// 2) If the current location is older than the last location, ignore
		// the current location
		// 3) If the current location is newer than the last locations, keep the
		// current location.
		if(null == mLastLocationReading)
			this.mLastLocationReading = currentLocation;
		else if(currentLocation.getTime()>this.mLastLocationReading.getTime())
			this.mLastLocationReading = currentLocation;
		return;
	}

	@Override
	public void onProviderDisabled(String provider) {
		// not implemented
	}

	@Override
	public void onProviderEnabled(String provider) {
		// not implemented
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// not implemented
	}

	private long age(Location location) {
		return System.currentTimeMillis() - location.getTime();
	}	

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case R.id.print_badges:
			ArrayList<PlaceRecord> currData = mAdapter.getList();
			for (int i = 0; i < currData.size(); i++) {
				log(currData.get(i).toString());
			}
			return true;
		case R.id.delete_badges:
			mAdapter.removeAllViews();
			return true;
		case R.id.place_one:
			mMockLocationProvider.pushLocation(37.422, -122.084);
			return true;
		case R.id.place_invalid:
			mMockLocationProvider.pushLocation(0, 0);
			return true;
		case R.id.place_two:
			mMockLocationProvider.pushLocation(38.996667, -76.9275);
			return true;
		default:
			return super.onOptionsItemSelected(item);
		}
	}

	private static void log(String msg) {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		Log.i(TAG, msg);
	}

}
