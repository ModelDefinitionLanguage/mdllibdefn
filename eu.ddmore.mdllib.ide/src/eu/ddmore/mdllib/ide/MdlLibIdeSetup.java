/*
 * generated by Xtext
 */
package eu.ddmore.mdllib.ide;

import com.google.inject.Guice;
import com.google.inject.Injector;
import eu.ddmore.mdllib.MdlLibRuntimeModule;
import eu.ddmore.mdllib.MdlLibStandaloneSetup;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages as language servers.
 */
public class MdlLibIdeSetup extends MdlLibStandaloneSetup {

	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new MdlLibRuntimeModule(), new MdlLibIdeModule()));
	}
	
}